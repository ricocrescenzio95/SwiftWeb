import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntaxMacros
import Foundation

struct PageMacro {}

extension PageMacro: MemberMacro {
  static func expansion(
    of node: AttributeSyntax,
    providingMembersOf declaration: some DeclGroupSyntax,
    conformingTo protocols: [TypeSyntax],
    in context: some MacroExpansionContext
  ) throws -> [DeclSyntax] {
    guard let structDeclaration = validateStructDeclarationAttribute(attribute: node, declaration: declaration, in: context) else {
      return []
    }
    
    validateStruct(structDeclaration: structDeclaration, in: context)
    
    let pageAttributes = structDeclaration.attributes.filter { attribute in
      guard case let .attribute(attr) = attribute else { return false }
      return attr.attributeName.as(IdentifierTypeSyntax.self)?.name.text == "Page"
    }
    
    var cleanedAttributes = AttributeListSyntax("")
    var added = false
    for attribute in structDeclaration.attributes {
      if case let .attribute(attr) = attribute, attr.attributeName.as(IdentifierTypeSyntax.self)?.name.text == "Page" {
        if !added {
          cleanedAttributes.append(attribute)
          added = true
        }
      } else {
        cleanedAttributes.append(attribute)
      }
    }
    
    // If there's more than one @Page macro, throw an error with fix-it
    if pageAttributes.count > 1 {
      let diagnostic = Diagnostic(
        node: node,
        message: PageMacroDiagnostic.duplicatedPageMacro,
        fixIts: [
          FixIt(
            message: MacroExpansionFixItMessage("Remove duplicate @Page attributes"),
            changes: [
              .replace(
                oldNode: Syntax(structDeclaration.attributes),
                newNode: Syntax(cleanedAttributes)
              )
            ]
          )
        ]
      )
      context.diagnose(diagnostic)
    }
    
    // Extract and validate the route argument
    guard let argument = node.arguments?.as(LabeledExprListSyntax.self)?.first(where: { $0.label?.text == "route" }),
          let stringLiteral = argument.expression.as(StringLiteralExprSyntax.self) else {
      let diagnostic = Diagnostic(
        node: node,
        message: PageMacroDiagnostic.mustBeLiteral
      )
      context.diagnose(diagnostic)
      return []
    }
    
    validateRoute(stringLiteral: stringLiteral, in: context)
    
    return [
      """
      @available(*, unavailable, message: "Cannot initialize a WebPage with init. Use \(structDeclaration.name).makeDestination()")
      private init() {}
      """
    ]
  }
  
  static func validateStruct(
    structDeclaration: StructDeclSyntax,
    in context: some MacroExpansionContext
  ) {
    func diagnose(_ message: PageMacroDiagnostic) {
      let diagnostic = Diagnostic(
        node: structDeclaration,
        message: message
      )
      context.diagnose(diagnostic)
    }
    let modifiersTokens = [Keyword.internal, .private, .fileprivate, .package, .public, .open]
    let accessModifier = structDeclaration
      .modifiers
      .first {
        modifiersTokens.map { TokenKind.keyword($0) }.contains($0.name.tokenKind)
      }
      .map(\.name.tokenKind)
    
    guard accessModifier != .keyword(.private) &&
          accessModifier != .keyword(.fileprivate) else {
      diagnose(.pageMustNotBePrivate)
      return
    }
    
    for member in structDeclaration.memberBlock.members {
      if member.decl.is(InitializerDeclSyntax.self) {
        diagnose(.pageCannotHaveInit)
        return
      }
    }
  }
  
  /// Validates the route string literal according to the rules:
  /// - Route must be a valid URL path component
  /// - Only `\(param: "name")` or `\(param: "name", Type.self)` interpolation is allowed
  /// - Parameter names must be non-empty string literals
  /// - Parameter names must not contain spaces or invalid URL characters
  /// - Each path segment (delimited by /) must contain EITHER a static string OR a single param
  static func validateRoute(
    stringLiteral: StringLiteralExprSyntax,
    in context: some MacroExpansionContext
  ) {
    let segments = stringLiteral.segments
    
    // First pass: validate individual segments
    for segment in segments {
      switch segment {
      case .stringSegment(let stringSegment):
        // Validate static path components
        let text = stringSegment.content.text
        if segments.count == 1, text.isEmpty {
          let diagnostic = Diagnostic(
            node: segment,
            message: PageMacroDiagnostic.emptyString
          )
          context.diagnose(diagnostic)
        } else {
          validatePathComponent(text, node: stringSegment, in: context)
        }
        
      case .expressionSegment(let expressionSegment):
        // Validate interpolation - must be in form \(param: "name") or \(param: "name", Type.self)
        validateParamInterpolation(expressionSegment, in: context)
      }
    }
    
    // Second pass: validate path segment structure
    validatePathSegments(segments: segments, in: context)
  }
  
  /// Validates that each path segment (delimited by /) contains either a static string OR a single param
  static func validatePathSegments(
    segments: StringLiteralSegmentListSyntax,
    in context: some MacroExpansionContext
  ) {
    // Build up path segments by tracking what's between slashes
    var currentSegmentParts: [(isParam: Bool, node: Syntax)] = []
    
    for segment in segments {
      switch segment {
      case .stringSegment(let stringSegment):
        let text = stringSegment.content.text
        
        // Split by "/" to identify path boundaries
        let parts = text.split(separator: "/", omittingEmptySubsequences: false)
        
        for (index, part) in parts.enumerated() {
          if index > 0 {
            // We hit a "/" - validate the previous segment
            validateSinglePathSegment(parts: currentSegmentParts, in: context)
            currentSegmentParts = []
          }
          
          // Add non-empty string parts to current segment
          if !part.isEmpty {
            currentSegmentParts.append((isParam: false, node: Syntax(stringSegment)))
          }
        }
        
      case .expressionSegment(let expressionSegment):
        // Add param interpolation to current segment
        currentSegmentParts.append((isParam: true, node: Syntax(expressionSegment)))
      }
    }
    
    // Validate the final segment
    if !currentSegmentParts.isEmpty {
      validateSinglePathSegment(parts: currentSegmentParts, in: context)
    }
  }
  
  /// Validates that a single path segment contains either static text OR a single param, not mixed
  static func validateSinglePathSegment(
    parts: [(isParam: Bool, node: Syntax)],
    in context: some MacroExpansionContext
  ) {
    guard !parts.isEmpty else { return }
    
    let hasStaticText = parts.contains { !$0.isParam }
    let hasParam = parts.contains { $0.isParam }
    let paramCount = parts.filter { $0.isParam }.count
    
    // Error: mixing static text with param in same segment
    if hasStaticText && hasParam {
      let firstParam = parts.first { $0.isParam }!
      let diagnostic = Diagnostic(
        node: firstParam.node,
        message: PageMacroDiagnostic.mixedPathSegment,
        highlights: parts.map { $0.node }
      )
      context.diagnose(diagnostic)
      return
    }
    
    // Error: multiple params in same segment
    if paramCount > 1 {
      let params = parts.filter { $0.isParam }
      let diagnostic = Diagnostic(
        node: params[0].node,
        message: PageMacroDiagnostic.multipleParamsInSegment,
        highlights: params.map { $0.node }
      )
      context.diagnose(diagnostic)
    }
  }
  
  /// Validates that a path component contains only valid URL characters
  static func validatePathComponent(
    _ text: String,
    node: some SyntaxProtocol,
    in context: some MacroExpansionContext
  ) {
    let invalidChars = CharacterSet.urlPathAllowed.inverted
    if let _ = text.rangeOfCharacter(from: invalidChars) {
      let diagnostic = Diagnostic(
        node: node,
        message: PageMacroDiagnostic.invalidPathComponent(text)
      )
      context.diagnose(diagnostic)
    }
  }
  
  /// Validates that expression interpolation uses the `param:` label with a string literal
  static func validateParamInterpolation(
    _ expressionSegment: ExpressionSegmentSyntax,
    in context: some MacroExpansionContext
  ) {
    // The expression list in the interpolation
    let expressions = expressionSegment.expressions
    
    guard !expressions.isEmpty else {
      let diagnostic = Diagnostic(
        node: expressionSegment,
        message: PageMacroDiagnostic.invalidInterpolation,
        highlights: [Syntax(expressionSegment)]
      )
      context.diagnose(diagnostic)
      return
    }
    
    // Check if first element has "param" label - this is the tuple-style syntax: \(param: "name")
    let firstExpr = expressions.first!
    if firstExpr.label?.text == "param" {
      // This is \(param: "name") syntax - validate it
      validateLabeledParamSyntax(expressions: expressions, expressionSegment: expressionSegment, in: context)
      return
    }
    
    // Otherwise, try to parse the expression itself for other forms
    if let tupleExpr = firstExpr.expression.as(TupleExprSyntax.self) {
      validateTupleParamSyntax(tupleExpr: tupleExpr, expressionSegment: expressionSegment, in: context)
      return
    }
    
    if let functionCall = firstExpr.expression.as(FunctionCallExprSyntax.self) {
      validateFunctionCallParamSyntax(functionCall, expressionSegment: expressionSegment, in: context)
      return
    }
    
    // Not a valid param interpolation format
    let diagnostic = Diagnostic(
      node: expressionSegment,
      message: PageMacroDiagnostic.invalidInterpolation,
      highlights: [Syntax(expressionSegment)]
    )
    context.diagnose(diagnostic)
  }
  
  /// Validates labeled param syntax directly in expression list: \(param: "name")
  static func validateLabeledParamSyntax(
    expressions: LabeledExprListSyntax,
    expressionSegment: ExpressionSegmentSyntax,
    in context: some MacroExpansionContext
  ) {
    let firstExpr = expressions.first!
    
    // First expression must be a string literal
    guard let stringLiteral = firstExpr.expression.as(StringLiteralExprSyntax.self) else {
      let diagnostic = Diagnostic(
        node: firstExpr,
        message: PageMacroDiagnostic.paramMustBeLiteral,
        highlights: [Syntax(firstExpr)]
      )
      context.diagnose(diagnostic)
      return
    }
    
    // Validate the parameter name
    validateParamName(stringLiteral: stringLiteral, node: firstExpr, in: context)
    
    // Allow optional second argument for type (no validation needed)
    if expressions.count > 2 {
      let diagnostic = Diagnostic(
        node: expressionSegment,
        message: PageMacroDiagnostic.tooManyParamArguments,
        highlights: [Syntax(expressionSegment)]
      )
      context.diagnose(diagnostic)
    }
  }
  
  /// Validates tuple-style param syntax: \(param: "name") or \(param: "name", String.self)
  static func validateTupleParamSyntax(
    tupleExpr: TupleExprSyntax,
    expressionSegment: ExpressionSegmentSyntax,
    in context: some MacroExpansionContext
  ) {
    let elements = tupleExpr.elements
    
    guard !elements.isEmpty else {
      let diagnostic = Diagnostic(
        node: expressionSegment,
        message: PageMacroDiagnostic.invalidInterpolation,
        highlights: [Syntax(expressionSegment)]
      )
      context.diagnose(diagnostic)
      return
    }
    
    // First element must have label "param"
    let firstElement = elements.first!
    guard firstElement.label?.text == "param" else {
      let diagnostic = Diagnostic(
        node: expressionSegment,
        message: PageMacroDiagnostic.invalidInterpolation,
        highlights: [Syntax(expressionSegment)]
      )
      context.diagnose(diagnostic)
      return
    }
    
    // First argument must be a string literal
    guard let stringLiteral = firstElement.expression.as(StringLiteralExprSyntax.self) else {
      let diagnostic = Diagnostic(
        node: firstElement,
        message: PageMacroDiagnostic.paramMustBeLiteral,
        highlights: [Syntax(firstElement)]
      )
      context.diagnose(diagnostic)
      return
    }
    
    // Extract and validate the parameter name
    validateParamName(stringLiteral: stringLiteral, node: firstElement, in: context)
    
    // Allow optional second argument for type (no validation needed)
    if elements.count > 2 {
      let diagnostic = Diagnostic(
        node: expressionSegment,
        message: PageMacroDiagnostic.tooManyParamArguments,
        highlights: [Syntax(expressionSegment)]
      )
      context.diagnose(diagnostic)
    }
  }
  
  /// Validates function-call-style param syntax: param("name") or param("name", String.self)
  static func validateFunctionCallParamSyntax(
    _ functionCall: FunctionCallExprSyntax,
    expressionSegment: ExpressionSegmentSyntax,
    in context: some MacroExpansionContext
  ) {
    // Check if the function is "param"
    guard let identifierExpr = functionCall.calledExpression.as(DeclReferenceExprSyntax.self),
          identifierExpr.baseName.text == "param" else {
      let diagnostic = Diagnostic(
        node: expressionSegment,
        message: PageMacroDiagnostic.invalidInterpolation,
        highlights: [Syntax(expressionSegment)]
      )
      context.diagnose(diagnostic)
      return
    }
    
    // Get the arguments
    let arguments = functionCall.arguments
    
    guard !arguments.isEmpty else {
      let diagnostic = Diagnostic(
        node: expressionSegment,
        message: PageMacroDiagnostic.emptyParamName,
        highlights: [Syntax(expressionSegment)]
      )
      context.diagnose(diagnostic)
      return
    }
    
    // First argument must be a non-empty string literal (the parameter name)
    let firstArg = arguments.first!
    guard let stringLiteral = firstArg.expression.as(StringLiteralExprSyntax.self) else {
      let diagnostic = Diagnostic(
        node: firstArg,
        message: PageMacroDiagnostic.paramMustBeLiteral,
        highlights: [Syntax(firstArg)]
      )
      context.diagnose(diagnostic)
      return
    }
    
    // Extract and validate the parameter name
    validateParamName(stringLiteral: stringLiteral, node: firstArg, in: context)
    
    // Allow optional second argument for type (no validation needed)
    if arguments.count > 2 {
      let diagnostic = Diagnostic(
        node: expressionSegment,
        message: PageMacroDiagnostic.tooManyParamArguments,
        highlights: [Syntax(expressionSegment)]
      )
      context.diagnose(diagnostic)
    }
  }
  
  /// Validates the parameter name from a string literal
  static func validateParamName(
    stringLiteral: StringLiteralExprSyntax,
    node: some SyntaxProtocol,
    in context: some MacroExpansionContext
  ) {
    // Extract the string value
    guard let stringSegment = stringLiteral.segments.first?.as(StringSegmentSyntax.self) else {
      let diagnostic = Diagnostic(
        node: node,
        message: PageMacroDiagnostic.emptyParamName,
        highlights: [Syntax(node)]
      )
      context.diagnose(diagnostic)
      return
    }
    
    let paramName = stringSegment.content.text
    
    // Check if parameter name is empty
    if paramName.isEmpty {
      let diagnostic = Diagnostic(
        node: node,
        message: PageMacroDiagnostic.emptyParamName,
        highlights: [Syntax(node)]
      )
      context.diagnose(diagnostic)
      return
    }
    
    // Check if parameter name contains spaces or invalid URL characters
    if paramName.contains(" ") {
      let diagnostic = Diagnostic(
        node: node,
        message: PageMacroDiagnostic.paramNameContainsSpaces,
        highlights: [Syntax(node)]
      )
      context.diagnose(diagnostic)
      return
    }
    
    let invalidChars = CharacterSet.urlPathAllowed.inverted
    if let _ = paramName.rangeOfCharacter(from: invalidChars) {
      let diagnostic = Diagnostic(
        node: node,
        message: PageMacroDiagnostic.invalidPathComponent(paramName),
        highlights: [Syntax(node)]
      )
      context.diagnose(diagnostic)
    }
  }
}

extension PageMacro: ExtensionMacro {
  static func expansion(
    of node: AttributeSyntax,
    attachedTo declaration: some DeclGroupSyntax,
    providingExtensionsOf type: some TypeSyntaxProtocol,
    conformingTo protocols: [TypeSyntax],
    in context: some MacroExpansionContext
  ) throws -> [ExtensionDeclSyntax] {
    guard let structDeclaration = validateStructDeclarationAttribute(attribute: node, declaration: declaration, in: context) else {
      return []
    }
    
    let componentAttributes = structDeclaration.attributes.filter { attribute in
      guard case let .attribute(attr) = attribute else { return false }
      return attr.attributeName.as(IdentifierTypeSyntax.self)?.name.text == "Component"
    }
    
    // Extract route argument and parameters
    guard let argument = node.arguments?.as(LabeledExprListSyntax.self)?.first(where: { $0.label?.text == "route" }),
          let stringLiteral = argument.expression.as(StringLiteralExprSyntax.self) else {
      var extensions: [ExtensionDeclSyntax] = []
      
      if componentAttributes.count == 0 {
        try extensions.append(
          contentsOf: ComponentMacro.expansion(
            of: node,
            attachedTo: declaration,
            providingExtensionsOf: type,
            conformingTo: protocols,
            in: context
          )
        )
      }
      return extensions
    }
    
    let params = extractParameters(from: stringLiteral, context: context)
    let routeExprString = stringLiteral.description.trimmingCharacters(in: .whitespaces)
    let typeName = structDeclaration.name.text
    
    // Generate route and parameter properties
    var members: [String] = [
      "init(_: Router.Context) {}",
      "public static let route: Route = \(routeExprString)"
    ]
    
    // Parameter properties
    for (index, param) in params.enumerated() {
      let paramTypeName = param.type ?? "String"
      members.append("""
        public var \(param.name): \(paramTypeName) {
          router.jsHandler.extractParamFromRoute(Self.route, index: \(index))
        }
        """)
    }
    
    let routableExtension = try ExtensionDeclSyntax("extension \(type): WebPage") {
      for member in members {
        DeclSyntax(stringLiteral: member)
      }
      try generateMakeDestinationExtension(
        typeName: typeName,
        stringLiteral: stringLiteral,
        params: params
      )
    }
    
    var extensions: [ExtensionDeclSyntax] = [routableExtension]
        
    if componentAttributes.count == 0 {
      try extensions.append(
        contentsOf: ComponentMacro.expansion(
          of: node,
          attachedTo: declaration,
          providingExtensionsOf: type,
          conformingTo: protocols,
          in: context
        )
      )
    }
    
    return extensions
  }
  
  /// Generates Router.Routes extension with push and replace functions
  static func generateMakeDestinationExtension(
    typeName: String,
    stringLiteral: StringLiteralExprSyntax,
    params: [(name: String, type: String?)]
  ) throws -> DeclSyntax {
    // Build function parameters
    let funcParams = params.map { param -> String in
      let type = param.type ?? "String"
      return "\(param.name): \(type)"
    }.joined(separator: ", ")
    
    return if params.isEmpty {
      """
      static func makeDestination() -> PageDestination<\(raw: typeName)> {
        PageDestination(page: \(raw: typeName).self)
      }
      """
    } else {
      """
      static func makeDestination(\(raw: funcParams)) -> PageDestination<\(raw: typeName)> {
        PageDestination(page: \(raw: typeName).self, params: \(raw: params.map(\.name).joined(separator: ", ")))
      }
      """
    }
  }
  
  /// Extracts parameter information from the route string literal
  static func extractParameters(
    from stringLiteral: StringLiteralExprSyntax,
    context: some MacroExpansionContext
  ) -> [(name: String, type: String?)] {
    var params: [(name: String, type: String?)] = []
    
    for segment in stringLiteral.segments {
      if case .expressionSegment(let exprSegment) = segment {
        // Extract param name and type
        if let paramInfo = extractParamInfo(from: exprSegment) {
          if params.first(where: { $0.name == paramInfo.name }) != nil {
            let diagnostic = Diagnostic(
              node: segment,
              message: PageMacroDiagnostic.duplicatedParamName(paramInfo.name)
            )
            context.diagnose(diagnostic)
          } else {
            params.append(paramInfo)
          }
        }
      }
    }
    
    return params
  }
  
  /// Extracts parameter name and type from an expression segment
  static func extractParamInfo(from segment: ExpressionSegmentSyntax) -> (name: String, type: String?)? {
    let expressions = segment.expressions
    
    var paramName: String?
    var paramType: String?
    
    for expr in expressions {
      // Look for labeled expression with label "param"
      if expr.label?.text == "param",
         let stringLiteral = expr.expression.as(StringLiteralExprSyntax.self),
         let firstSegment = stringLiteral.segments.first,
         case .stringSegment(let stringSegment) = firstSegment {
        paramName = stringSegment.content.text
      }
      
      // Look for type argument (unlabeled, second argument)
      if expr.label == nil,
         let memberAccess = expr.expression.as(MemberAccessExprSyntax.self),
         memberAccess.declName.baseName.text == "self",
         let base = memberAccess.base {
        // Extract type name from Type.self
        paramType = base.description.trimmingCharacters(in: .whitespaces)
      }
    }
    
    guard let name = paramName else { return nil }
    return (name: name, type: paramType)
  }
}

enum PageMacroDiagnostic: DiagnosticMessage {
  case pageCannotHaveInit
  case pageMustNotBePrivate
  case emptyString
  case mustBeLiteral
  case duplicatedPageMacro
  case invalidInterpolation
  case paramMustBeLiteral
  case emptyParamName
  case duplicatedParamName(String)
  case paramNameContainsSpaces
  case invalidPathComponent(String)
  case tooManyParamArguments
  case mixedPathSegment
  case multipleParamsInSegment
  
  var message: String {
    switch self {
    case .pageMustNotBePrivate:
      return "Page must not be private or fileprivate"
    case .pageCannotHaveInit:
      return "Page cannot have custom initializer. Use router to navigate to a Web Page"
    case .emptyString:
      return "Route must not be empty"
    case .mustBeLiteral:
      return "'route' param must be a String literal"
    case .duplicatedPageMacro:
      return "Multiple @Page macros are not allowed on the same declaration"
    case .invalidInterpolation:
      return "Route interpolation must use the \\(param: \"name\") or \\(param: \"name\", Type.self) syntax"
    case .paramMustBeLiteral:
      return "Parameter name must be a string literal, not a variable or expression"
    case .emptyParamName:
      return "Parameter name cannot be empty"
    case .duplicatedParamName(let text):
      return "Parameter '\(text)' is already used"
    case .paramNameContainsSpaces:
      return "Parameter name cannot contain spaces"
    case .invalidPathComponent(let text):
      return "'\(text)' contains invalid URL path characters"
    case .tooManyParamArguments:
      return "param() accepts at most 2 arguments: name and optional type"
    case .mixedPathSegment:
      return "Path segment cannot mix static text with parameter interpolation. Each segment must be either static text OR a single parameter"
    case .multipleParamsInSegment:
      return "Path segment cannot contain multiple parameters. Each segment must contain at most one parameter"
    }
  }
  
  var diagnosticID: MessageID {
    switch self {
    case .pageMustNotBePrivate:
      return MessageID(domain: "PageMacro", id: "pageMustNotBePrivate")
    case .pageCannotHaveInit:
      return MessageID(domain: "PageMacro", id: "pageCannotHaveInit")
    case .emptyString:
      return MessageID(domain: "PageMacro", id: "emptyString")
    case .mustBeLiteral:
      return MessageID(domain: "PageMacro", id: "mustBeLiteral")
    case .duplicatedPageMacro:
      return MessageID(domain: "PageMacro", id: "duplicatedPageMacro")
    case .invalidInterpolation:
      return MessageID(domain: "PageMacro", id: "invalidInterpolation")
    case .paramMustBeLiteral:
      return MessageID(domain: "PageMacro", id: "paramMustBeLiteral")
    case .emptyParamName:
      return MessageID(domain: "PageMacro", id: "emptyParamName")
    case .duplicatedParamName:
      return MessageID(domain: "PageMacro", id: "duplicatedParamName")
    case .paramNameContainsSpaces:
      return MessageID(domain: "PageMacro", id: "paramNameContainsSpaces")
    case .invalidPathComponent:
      return MessageID(domain: "PageMacro", id: "invalidPathComponent")
    case .tooManyParamArguments:
      return MessageID(domain: "PageMacro", id: "tooManyParamArguments")
    case .mixedPathSegment:
      return MessageID(domain: "PageMacro", id: "mixedPathSegment")
    case .multipleParamsInSegment:
      return MessageID(domain: "PageMacro", id: "multipleParamsInSegment")
    }
  }
  
  var severity: DiagnosticSeverity {
    .error
  }
}
