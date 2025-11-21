private typealias CSSType = Sendable & Hashable & Codable

extension CSS {
  public enum Unit: CSSType, ExpressibleByFloatLiteral, ExpressibleByIntegerLiteral, ExpressibleByNilLiteral {
    // Absolute length units
    case px(Double)      // Pixels
    case cm(Double)      // Centimeters
    case mm(Double)      // Millimeters
    case q(Double)       // Quarter-millimeters
    case inches(Double)  // Inches (1in = 96px = 2.54cm)
    case pc(Double)      // Picas (1pc = 12pt)
    case pt(Double)      // Points (1pt = 1/72 of 1in)
    
    // Relative length units
    case em(Double)      // Relative to font-size of the element
    case ex(Double)      // Relative to x-height of the current font
    case ch(Double)      // Relative to width of the "0" character
    case rem(Double)     // Relative to font-size of the root element
    case lh(Double)      // Relative to line-height of the element
    case rlh(Double)     // Relative to line-height of the root element
    
    // Viewport-percentage units
    case vw(Double)      // 1% of viewport width
    case vh(Double)      // 1% of viewport height
    case vmin(Double)    // 1% of viewport's smaller dimension
    case vmax(Double)    // 1% of viewport's larger dimension
    case vb(Double)      // 1% of viewport size in block axis
    case vi(Double)      // 1% of viewport size in inline axis
    
    // Container query units
    case cqw(Double)     // 1% of container's width
    case cqh(Double)     // 1% of container's height
    case cqi(Double)     // 1% of container's inline size
    case cqb(Double)     // 1% of container's block size
    case cqmin(Double)   // Smaller of cqi or cqb
    case cqmax(Double)   // Larger of cqi or cqb
    
    // Percentage
    case percent(Double) // Percentage relative to parent
    
    // Special values
    case auto
    case zero
    
    // Flexible units (for grid/flexbox)
    case fr(Double)      // Fraction of available space
    
    // Convierte el valor a string CSS
    public var css: String {
      switch self {
      // Absolute length units
      case .px(let value): return "\(value)px"
      case .cm(let value): return "\(value)cm"
      case .mm(let value): return "\(value)mm"
      case .q(let value): return "\(value)q"
      case .inches(let value): return "\(value)in"
      case .pc(let value): return "\(value)pc"
      case .pt(let value): return "\(value)pt"
      
      // Relative length units
      case .em(let value): return "\(value)em"
      case .ex(let value): return "\(value)ex"
      case .ch(let value): return "\(value)ch"
      case .rem(let value): return "\(value)rem"
      case .lh(let value): return "\(value)lh"
      case .rlh(let value): return "\(value)rlh"
      
      // Viewport-percentage units
      case .vw(let value): return "\(value)vw"
      case .vh(let value): return "\(value)vh"
      case .vmin(let value): return "\(value)vmin"
      case .vmax(let value): return "\(value)vmax"
      case .vb(let value): return "\(value)vb"
      case .vi(let value): return "\(value)vi"
      
      // Container query units
      case .cqw(let value): return "\(value)cqw"
      case .cqh(let value): return "\(value)cqh"
      case .cqi(let value): return "\(value)cqi"
      case .cqb(let value): return "\(value)cqb"
      case .cqmin(let value): return "\(value)cqmin"
      case .cqmax(let value): return "\(value)cqmax"
      
      // Percentage
      case .percent(let value): return "\(value)%"
      
      // Special values
      case .auto: return "auto"
      case .zero: return "0"
      
      // Flexible units
      case .fr(let value): return "\(value)fr"
      }
    }
    
    public init(floatLiteral value: Double) {
      self = .px(value)
    }
    
    public init(integerLiteral value: IntegerLiteralType) {
      self = .px(Double(value))
    }
    
    public init(nilLiteral: ()) {
      self = .auto
    }
  }
}

extension BinaryInteger {
  public var px: CSS.Unit {
    .px(Double(self))
  }
  public var cm: CSS.Unit {
    .cm(Double(self))
  }
  public var mm: CSS.Unit {
    .mm(Double(self))
  }
  public var q: CSS.Unit {
    .q(Double(self))
  }
  public var inches: CSS.Unit {
    .inches(Double(self))
  }
  public var pc: CSS.Unit {
    .pc(Double(self))
  }
  public var pt: CSS.Unit {
    .pt(Double(self))
  }
  public var em: CSS.Unit {
    .em(Double(self))
  }
  public var ex: CSS.Unit {
    .ex(Double(self))
  }
  public var ch: CSS.Unit {
    .ch(Double(self))
  }
  public var rem: CSS.Unit {
    .rem(Double(self))
  }
  public var lh: CSS.Unit {
    .lh(Double(self))
  }
  public var rlh: CSS.Unit {
    .rlh(Double(self))
  }
  public var vw: CSS.Unit {
    .vw(Double(self))
  }
  public var vh: CSS.Unit {
    .vh(Double(self))
  }
  public var vmin: CSS.Unit {
    .vmin(Double(self))
  }
  public var vmax: CSS.Unit {
    .vmax(Double(self))
  }
  public var vb: CSS.Unit {
    .vb(Double(self))
  }
  public var vi: CSS.Unit {
    .vi(Double(self))
  }
  public var cqw: CSS.Unit {
    .cqw(Double(self))
  }
  public var cqh: CSS.Unit {
    .cqh(Double(self))
  }
  public var cqi: CSS.Unit {
    .cqi(Double(self))
  }
  public var cqb: CSS.Unit {
    .cqb(Double(self))
  }
  public var cqmin: CSS.Unit {
    .cqmin(Double(self))
  }
  public var cqmax: CSS.Unit {
    .cqmax(Double(self))
  }
  public var percent: CSS.Unit {
    .percent(Double(self))
  }
  public var fr: CSS.Unit {
    .fr(Double(self))
  }
}

extension BinaryFloatingPoint {
  public var px: CSS.Unit {
    .px(Double(self))
  }
  public var cm: CSS.Unit {
    .cm(Double(self))
  }
  public var mm: CSS.Unit {
    .mm(Double(self))
  }
  public var q: CSS.Unit {
    .q(Double(self))
  }
  public var inches: CSS.Unit {
    .inches(Double(self))
  }
  public var pc: CSS.Unit {
    .pc(Double(self))
  }
  public var pt: CSS.Unit {
    .pt(Double(self))
  }
  public var em: CSS.Unit {
    .em(Double(self))
  }
  public var ex: CSS.Unit {
    .ex(Double(self))
  }
  public var ch: CSS.Unit {
    .ch(Double(self))
  }
  public var rem: CSS.Unit {
    .rem(Double(self))
  }
  public var lh: CSS.Unit {
    .lh(Double(self))
  }
  public var rlh: CSS.Unit {
    .rlh(Double(self))
  }
  public var vw: CSS.Unit {
    .vw(Double(self))
  }
  public var vh: CSS.Unit {
    .vh(Double(self))
  }
  public var vmin: CSS.Unit {
    .vmin(Double(self))
  }
  public var vmax: CSS.Unit {
    .vmax(Double(self))
  }
  public var vb: CSS.Unit {
    .vb(Double(self))
  }
  public var vi: CSS.Unit {
    .vi(Double(self))
  }
  public var cqw: CSS.Unit {
    .cqw(Double(self))
  }
  public var cqh: CSS.Unit {
    .cqh(Double(self))
  }
  public var cqi: CSS.Unit {
    .cqi(Double(self))
  }
  public var cqb: CSS.Unit {
    .cqb(Double(self))
  }
  public var cqmin: CSS.Unit {
    .cqmin(Double(self))
  }
  public var cqmax: CSS.Unit {
    .cqmax(Double(self))
  }
  public var percent: CSS.Unit {
    .percent(Double(self))
  }
  public var fr: CSS.Unit {
    .fr(Double(self))
  }
}

extension CSS {
  public struct Box: CSSType, ExpressibleByFloatLiteral, ExpressibleByIntegerLiteral, ExpressibleByNilLiteral {
    public var top: Unit
    public var right: Unit
    public var bottom: Unit
    public var left: Unit
    
    // All four sides
    public init(top: Unit = .auto, right: Unit = .auto, bottom: Unit = .auto, left: Unit = .auto) {
      self.top = top
      self.right = right
      self.bottom = bottom
      self.left = left
    }
    
    // All sides the same
    public init(_ all: Unit) {
      self.top = all
      self.right = all
      self.bottom = all
      self.left = all
    }
    
    // Vertical and horizontal
    @_disfavoredOverload
    public init(vertical: Unit = .auto, horizontal: Unit = .auto) {
      self.top = vertical
      self.right = horizontal
      self.bottom = vertical
      self.left = horizontal
    }
    
    // Top, horizontal, bottom
    public init(top: Unit, horizontal: Unit, bottom: Unit) {
      self.top = top
      self.right = horizontal
      self.bottom = bottom
      self.left = horizontal
    }
    
    //  string representation
    public var css: String {
      // Optimize output based on which values are equal
      if top == right && right == bottom && bottom == left {
        // All the same: "10px"
        return top.css
      } else if top == bottom && right == left {
        // Vertical/Horizontal: "10px 20px"
        return "\(top.css) \(right.css)"
      } else if right == left {
        // Top, Horizontal, Bottom: "10px 20px 30px"
        return "\(top.css) \(right.css) \(bottom.css)"
      } else {
        // All different: "10px 20px 30px 40px"
        return "\(top.css) \(right.css) \(bottom.css) \(left.css)"
      }
    }
    
    public init(floatLiteral value: Double) {
      self = .init(.px(value))
    }
    
    public init(integerLiteral value: IntegerLiteralType) {
      self = .init(.px(Double(value)))
    }
    
    public init(nilLiteral: ()) {
      self = .init(.auto)
    }
  }
  
  // MARK: - Value Types
  
  public enum Color: CSSType {
    case hex(String)
    case rgb(red: Int, green: Int, blue: Int)
    case rgba(red: Int, green: Int, blue: Int, alpha: Double)
    case hsl(hue: Int, saturation: Int, lightness: Int)
    case hsla(hue: Int, saturation: Int, lightness: Int, alpha: Double)
    case named(String)
    case currentColor
    case transparent
    case raw(String)
    
    public var css: String {
      switch self {
      case .hex(let value): return value
      case .rgb(let r, let g, let b): return "rgb(\(r), \(g), \(b))"
      case .rgba(let r, let g, let b, let a): return "rgba(\(r), \(g), \(b), \(a))"
      case .hsl(let h, let s, let l): return "hsl(\(h), \(s)%, \(l)%)"
      case .hsla(let h, let s, let l, let a): return "hsla(\(h), \(s)%, \(l)%, \(a))"
      case .named(let name): return name
      case .currentColor: return "currentColor"
      case .transparent: return "transparent"
      case .raw(let value): return value
      }
    }
    
    // MARK: - Named Colors (Basic)
    public static let black = Color.named("black")
    public static let white = Color.named("white")
    public static let red = Color.named("red")
    public static let green = Color.named("green")
    public static let blue = Color.named("blue")
    public static let yellow = Color.named("yellow")
    public static let cyan = Color.named("cyan")
    public static let magenta = Color.named("magenta")
    public static let gray = Color.named("gray")
    public static let grey = Color.named("grey")
    public static let silver = Color.named("silver")
    public static let maroon = Color.named("maroon")
    public static let olive = Color.named("olive")
    public static let lime = Color.named("lime")
    public static let aqua = Color.named("aqua")
    public static let teal = Color.named("teal")
    public static let navy = Color.named("navy")
    public static let fuchsia = Color.named("fuchsia")
    public static let purple = Color.named("purple")
    
    // MARK: - Extended Colors
    public static let aliceBlue = Color.named("aliceblue")
    public static let antiqueWhite = Color.named("antiquewhite")
    public static let aquamarine = Color.named("aquamarine")
    public static let azure = Color.named("azure")
    public static let beige = Color.named("beige")
    public static let bisque = Color.named("bisque")
    public static let blanchedAlmond = Color.named("blanchedalmond")
    public static let blueViolet = Color.named("blueviolet")
    public static let brown = Color.named("brown")
    public static let burlyWood = Color.named("burlywood")
    public static let cadetBlue = Color.named("cadetblue")
    public static let chartreuse = Color.named("chartreuse")
    public static let chocolate = Color.named("chocolate")
    public static let coral = Color.named("coral")
    public static let cornflowerBlue = Color.named("cornflowerblue")
    public static let cornsilk = Color.named("cornsilk")
    public static let crimson = Color.named("crimson")
    public static let darkBlue = Color.named("darkblue")
    public static let darkCyan = Color.named("darkcyan")
    public static let darkGoldenrod = Color.named("darkgoldenrod")
    public static let darkGray = Color.named("darkgray")
    public static let darkGrey = Color.named("darkgrey")
    public static let darkGreen = Color.named("darkgreen")
    public static let darkKhaki = Color.named("darkkhaki")
    public static let darkMagenta = Color.named("darkmagenta")
    public static let darkOliveGreen = Color.named("darkolivegreen")
    public static let darkOrange = Color.named("darkorange")
    public static let darkOrchid = Color.named("darkorchid")
    public static let darkRed = Color.named("darkred")
    public static let darkSalmon = Color.named("darksalmon")
    public static let darkSeaGreen = Color.named("darkseagreen")
    public static let darkSlateBlue = Color.named("darkslateblue")
    public static let darkSlateGray = Color.named("darkslategray")
    public static let darkSlateGrey = Color.named("darkslategrey")
    public static let darkTurquoise = Color.named("darkturquoise")
    public static let darkViolet = Color.named("darkviolet")
    public static let deepPink = Color.named("deeppink")
    public static let deepSkyBlue = Color.named("deepskyblue")
    public static let dimGray = Color.named("dimgray")
    public static let dimGrey = Color.named("dimgrey")
    public static let dodgerBlue = Color.named("dodgerblue")
    public static let firebrick = Color.named("firebrick")
    public static let floralWhite = Color.named("floralwhite")
    public static let forestGreen = Color.named("forestgreen")
    public static let gainsboro = Color.named("gainsboro")
    public static let ghostWhite = Color.named("ghostwhite")
    public static let gold = Color.named("gold")
    public static let goldenrod = Color.named("goldenrod")
    public static let greenYellow = Color.named("greenyellow")
    public static let honeydew = Color.named("honeydew")
    public static let hotPink = Color.named("hotpink")
    public static let indianRed = Color.named("indianred")
    public static let indigo = Color.named("indigo")
    public static let ivory = Color.named("ivory")
    public static let khaki = Color.named("khaki")
    public static let lavender = Color.named("lavender")
    public static let lavenderBlush = Color.named("lavenderblush")
    public static let lawnGreen = Color.named("lawngreen")
    public static let lemonChiffon = Color.named("lemonchiffon")
    public static let lightBlue = Color.named("lightblue")
    public static let lightCoral = Color.named("lightcoral")
    public static let lightCyan = Color.named("lightcyan")
    public static let lightGoldenrodYellow = Color.named("lightgoldenrodyellow")
    public static let lightGray = Color.named("lightgray")
    public static let lightGrey = Color.named("lightgrey")
    public static let lightGreen = Color.named("lightgreen")
    public static let lightPink = Color.named("lightpink")
    public static let lightSalmon = Color.named("lightsalmon")
    public static let lightSeaGreen = Color.named("lightseagreen")
    public static let lightSkyBlue = Color.named("lightskyblue")
    public static let lightSlateGray = Color.named("lightslategray")
    public static let lightSlateGrey = Color.named("lightslategrey")
    public static let lightSteelBlue = Color.named("lightsteelblue")
    public static let lightYellow = Color.named("lightyellow")
    public static let limeGreen = Color.named("limegreen")
    public static let linen = Color.named("linen")
    public static let mediumAquamarine = Color.named("mediumaquamarine")
    public static let mediumBlue = Color.named("mediumblue")
    public static let mediumOrchid = Color.named("mediumorchid")
    public static let mediumPurple = Color.named("mediumpurple")
    public static let mediumSeaGreen = Color.named("mediumseagreen")
    public static let mediumSlateBlue = Color.named("mediumslateblue")
    public static let mediumSpringGreen = Color.named("mediumspringgreen")
    public static let mediumTurquoise = Color.named("mediumturquoise")
    public static let mediumVioletRed = Color.named("mediumvioletred")
    public static let midnightBlue = Color.named("midnightblue")
    public static let mintCream = Color.named("mintcream")
    public static let mistyRose = Color.named("mistyrose")
    public static let moccasin = Color.named("moccasin")
    public static let navajoWhite = Color.named("navajowhite")
    public static let oldLace = Color.named("oldlace")
    public static let oliveDrab = Color.named("olivedrab")
    public static let orange = Color.named("orange")
    public static let orangeRed = Color.named("orangered")
    public static let orchid = Color.named("orchid")
    public static let paleGoldenrod = Color.named("palegoldenrod")
    public static let paleGreen = Color.named("palegreen")
    public static let paleTurquoise = Color.named("paleturquoise")
    public static let paleVioletRed = Color.named("palevioletred")
    public static let papayaWhip = Color.named("papayawhip")
    public static let peachPuff = Color.named("peachpuff")
    public static let peru = Color.named("peru")
    public static let pink = Color.named("pink")
    public static let plum = Color.named("plum")
    public static let powderBlue = Color.named("powderblue")
    public static let rosyBrown = Color.named("rosybrown")
    public static let royalBlue = Color.named("royalblue")
    public static let saddleBrown = Color.named("saddlebrown")
    public static let salmon = Color.named("salmon")
    public static let sandyBrown = Color.named("sandybrown")
    public static let seaGreen = Color.named("seagreen")
    public static let seashell = Color.named("seashell")
    public static let sienna = Color.named("sienna")
    public static let skyBlue = Color.named("skyblue")
    public static let slateBlue = Color.named("slateblue")
    public static let slateGray = Color.named("slategray")
    public static let slateGrey = Color.named("slategrey")
    public static let snow = Color.named("snow")
    public static let springGreen = Color.named("springgreen")
    public static let steelBlue = Color.named("steelblue")
    public static let tan = Color.named("tan")
    public static let thistle = Color.named("thistle")
    public static let tomato = Color.named("tomato")
    public static let turquoise = Color.named("turquoise")
    public static let violet = Color.named("violet")
    public static let wheat = Color.named("wheat")
    public static let whiteSmoke = Color.named("whitesmoke")
    public static let yellowGreen = Color.named("yellowgreen")
    public static let rebeccaPurple = Color.named("rebeccapurple")
  }
  
  public enum Display: String, CSSType {
    case block, inline, inlineBlock = "inline-block"
    case flex, inlineFlex = "inline-flex"
    case grid, inlineGrid = "inline-grid"
    case none, contents
    case table, tableRow = "table-row", tableCell = "table-cell"
    case listItem = "list-item"
    case flowRoot = "flow-root"
    
    public var css: String { rawValue }
  }
  
  public enum Position: String, CSSType {
    case `static`, relative, absolute, fixed, sticky
    
    public var css: String { rawValue }
  }
  
  public enum Visibility: String, CSSType {
    case visible, hidden, collapse
    
    public var css: String { rawValue }
  }
  
  public enum Overflow: String, CSSType {
    case visible, hidden, scroll, auto, clip
    
    public var css: String { rawValue }
  }
  
  public enum FlexDirection: String, CSSType {
    case row, rowReverse = "row-reverse"
    case column, columnReverse = "column-reverse"
    
    public var css: String { rawValue }
  }
  
  public enum FlexWrap: String, CSSType {
    case nowrap, wrap, wrapReverse = "wrap-reverse"
    
    public var css: String { rawValue }
  }
  
  public enum JustifyContent: String, CSSType {
    case flexStart = "flex-start", flexEnd = "flex-end", center
    case spaceBetween = "space-between", spaceAround = "space-around", spaceEvenly = "space-evenly"
    case start, end, left, right
    case stretch
    
    public var css: String { rawValue }
  }
  
  public enum AlignItems: String, CSSType {
    case flexStart = "flex-start", flexEnd = "flex-end", center
    case baseline, stretch
    case start, end, selfStart = "self-start", selfEnd = "self-end"
    
    public var css: String { rawValue }
  }
  
  public enum AlignContent: String, CSSType {
    case flexStart = "flex-start", flexEnd = "flex-end", center
    case spaceBetween = "space-between", spaceAround = "space-around", spaceEvenly = "space-evenly"
    case stretch, start, end
    
    public var css: String { rawValue }
  }
  
  public enum TextAlign: String, CSSType {
    case left, right, center, justify
    case start, end
    
    public var css: String { rawValue }
  }
  
  public enum FontWeight: CSSType {
    case normal, bold, bolder, lighter
    case weight(Int)
    
    public var css: String {
      switch self {
      case .normal: return "normal"
      case .bold: return "bold"
      case .bolder: return "bolder"
      case .lighter: return "lighter"
      case .weight(let value): return "\(value)"
      }
    }
  }
  
  public enum FontStyle: String, CSSType {
    case normal, italic, oblique
    
    public var css: String { rawValue }
  }
  
  public enum TextTransform: String, CSSType {
    case none, capitalize, uppercase, lowercase
    
    public var css: String { rawValue }
  }
  
  public enum TextDecoration: String, CSSType {
    case none, underline, overline, lineThrough = "line-through"
    
    public var css: String { rawValue }
  }
  
  public enum WhiteSpace: String, CSSType {
    case normal, nowrap, pre, preWrap = "pre-wrap", preLine = "pre-line", breakSpaces = "break-spaces"
    
    public var css: String { rawValue }
  }
  
  public enum WordBreak: String, CSSType {
    case normal, breakAll = "break-all", keepAll = "keep-all", breakWord = "break-word"
    
    public var css: String { rawValue }
  }
  
  public enum BoxSizing: String, CSSType {
    case contentBox = "content-box", borderBox = "border-box"
    
    public var css: String { rawValue }
  }
  
  public enum Cursor: String, CSSType {
    case auto, `default`, pointer, text, move, wait, help
    case notAllowed = "not-allowed", none
    case contextMenu = "context-menu", progress, cell, crosshair
    case grab, grabbing
    case nResize = "n-resize", sResize = "s-resize", eResize = "e-resize", wResize = "w-resize"
    case neResize = "ne-resize", nwResize = "nw-resize", seResize = "se-resize", swResize = "sw-resize"
    case ewResize = "ew-resize", nsResize = "ns-resize", neswResize = "nesw-resize", nwseResize = "nwse-resize"
    case colResize = "col-resize", rowResize = "row-resize"
    case allScroll = "all-scroll", zoomIn = "zoom-in", zoomOut = "zoom-out"
    
    public var css: String { rawValue }
  }
  
  public enum PointerEvents: String, CSSType {
    case auto, none
    
    public var css: String { rawValue }
  }
  
  public enum UserSelect: String, CSSType {
    case auto, none, text, all
    
    public var css: String { rawValue }
  }
  
  public enum ObjectFit: String, CSSType {
    case fill, contain, cover, none, scaleDown = "scale-down"
    
    public var css: String { rawValue }
  }
  
  public enum BorderStyle: String, CSSType {
    case none, hidden, dotted, dashed, solid, double, groove, ridge, inset, outset
    
    public var css: String { rawValue }
  }
  
  public enum ListStyleType: String, CSSType {
    case none, disc, circle, square, decimal
    case decimalLeadingZero = "decimal-leading-zero"
    case lowerRoman = "lower-roman", upperRoman = "upper-roman"
    case lowerAlpha = "lower-alpha", upperAlpha = "upper-alpha"
    case lowerGreek = "lower-greek", lowerLatin = "lower-latin", upperLatin = "upper-latin"
    
    public var css: String { rawValue }
  }
  
  public enum ListStylePosition: String, CSSType {
    case inside, outside
    
    public var css: String { rawValue }
  }
}
