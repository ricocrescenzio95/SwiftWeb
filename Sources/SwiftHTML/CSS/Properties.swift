extension CSS {
  public struct Body: Sendable, Hashable, Codable, Convertible {
    public var properties: [Property] = []
    
    public init(_ properties: [Property]) {
      self.properties = properties
    }
    
    public var cssValue: String {
      properties.lazy.map { $0.cssValue + ";" }.joined(separator: "\n  ")
    }
  }
}

extension CSS {
  public struct Property: Sendable, Hashable, Codable, Convertible, ExpressibleByStringLiteral {
    public let cssValue: String
    
    private init(_ cssValue: String) {
      self.cssValue = cssValue
    }
    
    // MARK: - Box Model - Margin
    public static func margin(_ box: Box) -> Property {
      Property("margin: \(box.cssValue)")
    }
    
    public static func marginBlock(_ unit: Unit) -> Property {
      Property("margin-block: \(unit.cssValue)")
    }
    
    public static func marginBlockStart(_ unit: Unit) -> Property {
      Property("margin-block-start: \(unit.cssValue)")
    }
    
    public static func marginBlockEnd(_ unit: Unit) -> Property {
      Property("margin-block-end: \(unit.cssValue)")
    }
    
    public static func marginInline(_ unit: Unit) -> Property {
      Property("margin-inline: \(unit.cssValue)")
    }
    
    public static func marginInlineStart(_ unit: Unit) -> Property {
      Property("margin-inline-start: \(unit.cssValue)")
    }
    
    public static func marginInlineEnd(_ unit: Unit) -> Property {
      Property("margin-inline-end: \(unit.cssValue)")
    }
    
    // MARK: - Box Model - Padding
    public static func padding(_ box: Box) -> Property {
      Property("padding: \(box.cssValue)")
    }
    
    public static func paddingBlock(_ unit: Unit) -> Property {
      Property("padding-block: \(unit.cssValue)")
    }
    
    public static func paddingBlockStart(_ unit: Unit) -> Property {
      Property("padding-block-start: \(unit.cssValue)")
    }
    
    public static func paddingBlockEnd(_ unit: Unit) -> Property {
      Property("padding-block-end: \(unit.cssValue)")
    }
    
    public static func paddingInline(_ unit: Unit) -> Property {
      Property("padding-inline: \(unit.cssValue)")
    }
    
    public static func paddingInlineStart(_ unit: Unit) -> Property {
      Property("padding-inline-start: \(unit.cssValue)")
    }
    
    public static func paddingInlineEnd(_ unit: Unit) -> Property {
      Property("padding-inline-end: \(unit.cssValue)")
    }
    
    // MARK: - Box Model - Border
    public static func border(_ value: String) -> Property {
      Property("border: \(value)")
    }
    
    public static func borderWidth(_ box: Box) -> Property {
      Property("border-width: \(box.cssValue)")
    }
    
    public static func borderStyle(_ style: BorderStyle) -> Property {
      Property("border-style: \(style.cssValue)")
    }
    
    public static func borderColor(_ color: Color) -> Property {
      Property("border-color: \(color.cssValue)")
    }
    
    public static func borderTop(_ value: String) -> Property {
      Property("border-top: \(value)")
    }
    
    public static func borderRight(_ value: String) -> Property {
      Property("border-right: \(value)")
    }
    
    public static func borderBottom(_ value: String) -> Property {
      Property("border-bottom: \(value)")
    }
    
    public static func borderLeft(_ value: String) -> Property {
      Property("border-left: \(value)")
    }
    
    public static func borderRadius(_ box: Box) -> Property {
      Property("border-radius: \(box.cssValue)")
    }
    
    // MARK: - Box Model - Outline
    public static func outline(_ value: String) -> Property {
      Property("outline: \(value)")
    }
    
    public static func outlineWidth(_ unit: Unit) -> Property {
      Property("outline-width: \(unit.cssValue)")
    }
    
    public static func outlineStyle(_ style: BorderStyle) -> Property {
      Property("outline-style: \(style.cssValue)")
    }
    
    public static func outlineColor(_ color: Color) -> Property {
      Property("outline-color: \(color.cssValue)")
    }
    
    public static func outlineOffset(_ unit: Unit) -> Property {
      Property("outline-offset: \(unit.cssValue)")
    }
    
    // MARK: - Dimensions
    public static func width(_ unit: Unit) -> Property {
      Property("width: \(unit.cssValue)")
    }
    
    public static func height(_ unit: Unit) -> Property {
      Property("height: \(unit.cssValue)")
    }
    
    public static func minWidth(_ unit: Unit) -> Property {
      Property("min-width: \(unit.cssValue)")
    }
    
    public static func minHeight(_ unit: Unit) -> Property {
      Property("min-height: \(unit.cssValue)")
    }
    
    public static func maxWidth(_ unit: Unit) -> Property {
      Property("max-width: \(unit.cssValue)")
    }
    
    public static func maxHeight(_ unit: Unit) -> Property {
      Property("max-height: \(unit.cssValue)")
    }
    
    public static func boxSizing(_ sizing: BoxSizing) -> Property {
      Property("box-sizing: \(sizing.cssValue)")
    }
    
    public static func aspectRatio(_ value: String) -> Property {
      Property("aspect-ratio: \(value)")
    }
    
    // MARK: - Display & Visibility
    public static func display(_ display: Display) -> Property {
      Property("display: \(display.cssValue)")
    }
    
    public static func visibility(_ visibility: Visibility) -> Property {
      Property("visibility: \(visibility.cssValue)")
    }
    
    public static func opacity(_ value: Double) -> Property {
      Property("opacity: \(value)")
    }
    
    public static func overflow(_ overflow: Overflow) -> Property {
      Property("overflow: \(overflow.cssValue)")
    }
    
    public static func overflowX(_ overflow: Overflow) -> Property {
      Property("overflow-x: \(overflow.cssValue)")
    }
    
    public static func overflowY(_ overflow: Overflow) -> Property {
      Property("overflow-y: \(overflow.cssValue)")
    }
    
    public static func overflowWrap(_ value: String) -> Property {
      Property("overflow-wrap: \(value)")
    }
    
    // MARK: - Position
    public static func position(_ position: Position) -> Property {
      Property("position: \(position.cssValue)")
    }
    
    public static func inset(_ box: Box) -> Property {
      Property("inset: \(box.cssValue)")
    }
    
    public static func insetBlock(_ unit: Unit) -> Property {
      Property("inset-block: \(unit.cssValue)")
    }
    
    public static func insetInline(_ unit: Unit) -> Property {
      Property("inset-inline: \(unit.cssValue)")
    }
    
    public static func zIndex(_ value: Int) -> Property {
      Property("z-index: \(value)")
    }
    
    // MARK: - Flexbox
    public static func flexDirection(_ direction: FlexDirection) -> Property {
      Property("flex-direction: \(direction.cssValue)")
    }
    
    public static func flexWrap(_ wrap: FlexWrap) -> Property {
      Property("flex-wrap: \(wrap.cssValue)")
    }
    
    public static func flexFlow(_ value: String) -> Property {
      Property("flex-flow: \(value)")
    }
    
    public static func justifyContent(_ justify: JustifyContent) -> Property {
      Property("justify-content: \(justify.cssValue)")
    }
    
    public static func alignItems(_ align: AlignItems) -> Property {
      Property("align-items: \(align.cssValue)")
    }
    
    public static func alignContent(_ align: AlignContent) -> Property {
      Property("align-content: \(align.cssValue)")
    }
    
    public static func alignSelf(_ align: AlignItems) -> Property {
      Property("align-self: \(align.cssValue)")
    }
    
    public static func flex(_ value: String) -> Property {
      Property("flex: \(value)")
    }
    
    public static func flexGrow(_ value: Double) -> Property {
      Property("flex-grow: \(value)")
    }
    
    public static func flexShrink(_ value: Double) -> Property {
      Property("flex-shrink: \(value)")
    }
    
    public static func flexBasis(_ unit: Unit) -> Property {
      Property("flex-basis: \(unit.cssValue)")
    }
    
    public static func order(_ value: Int) -> Property {
      Property("order: \(value)")
    }
    
    public static func gap(_ unit: Unit) -> Property {
      Property("gap: \(unit.cssValue)")
    }
    
    public static func rowGap(_ unit: Unit) -> Property {
      Property("row-gap: \(unit.cssValue)")
    }
    
    public static func columnGap(_ unit: Unit) -> Property {
      Property("column-gap: \(unit.cssValue)")
    }
    
    // MARK: - Grid
    public static func gridTemplateColumns(_ value: String) -> Property {
      Property("grid-template-columns: \(value)")
    }
    
    public static func gridTemplateRows(_ value: String) -> Property {
      Property("grid-template-rows: \(value)")
    }
    
    public static func gridTemplateAreas(_ value: String) -> Property {
      Property("grid-template-areas: \(value)")
    }
    
    public static func gridTemplate(_ value: String) -> Property {
      Property("grid-template: \(value)")
    }
    
    public static func gridAutoColumns(_ value: String) -> Property {
      Property("grid-auto-columns: \(value)")
    }
    
    public static func gridAutoRows(_ value: String) -> Property {
      Property("grid-auto-rows: \(value)")
    }
    
    public static func gridAutoFlow(_ value: String) -> Property {
      Property("grid-auto-flow: \(value)")
    }
    
    public static func gridColumn(_ value: String) -> Property {
      Property("grid-column: \(value)")
    }
    
    public static func gridColumnStart(_ value: String) -> Property {
      Property("grid-column-start: \(value)")
    }
    
    public static func gridColumnEnd(_ value: String) -> Property {
      Property("grid-column-end: \(value)")
    }
    
    public static func gridRow(_ value: String) -> Property {
      Property("grid-row: \(value)")
    }
    
    public static func gridRowStart(_ value: String) -> Property {
      Property("grid-row-start: \(value)")
    }
    
    public static func gridRowEnd(_ value: String) -> Property {
      Property("grid-row-end: \(value)")
    }
    
    public static func gridArea(_ value: String) -> Property {
      Property("grid-area: \(value)")
    }
    
    public static func justifyItems(_ justify: JustifyContent) -> Property {
      Property("justify-items: \(justify.cssValue)")
    }
    
    public static func justifySelf(_ justify: JustifyContent) -> Property {
      Property("justify-self: \(justify.cssValue)")
    }
    
    public static func placeItems(_ value: String) -> Property {
      Property("place-items: \(value)")
    }
    
    public static func placeContent(_ value: String) -> Property {
      Property("place-content: \(value)")
    }
    
    public static func placeSelf(_ value: String) -> Property {
      Property("place-self: \(value)")
    }
    
    // MARK: - Typography
    public static func color(_ color: Color) -> Property {
      Property("color: \(color.cssValue)")
    }
    
    public static func fontFamily(_ value: String) -> Property {
      Property("font-family: \(value)")
    }
    
    public static func fontSize(_ unit: Unit) -> Property {
      Property("font-size: \(unit.cssValue)")
    }
    
    public static func fontWeight(_ weight: FontWeight) -> Property {
      Property("font-weight: \(weight.cssValue)")
    }
    
    public static func fontStyle(_ style: FontStyle) -> Property {
      Property("font-style: \(style.cssValue)")
    }
    
    public static func fontVariant(_ value: String) -> Property {
      Property("font-variant: \(value)")
    }
    
    public static func font(_ value: String) -> Property {
      Property("font: \(value)")
    }
    
    public static func lineHeight(_ unit: Unit) -> Property {
      Property("line-height: \(unit.cssValue)")
    }
    
    public static func letterSpacing(_ unit: Unit) -> Property {
      Property("letter-spacing: \(unit.cssValue)")
    }
    
    public static func wordSpacing(_ unit: Unit) -> Property {
      Property("word-spacing: \(unit.cssValue)")
    }
    
    public static func textAlign(_ align: TextAlign) -> Property {
      Property("text-align: \(align.cssValue)")
    }
    
    public static func textAlignLast(_ align: TextAlign) -> Property {
      Property("text-align-last: \(align.cssValue)")
    }
    
    public static func textDecoration(_ decoration: TextDecoration) -> Property {
      Property("text-decoration: \(decoration.cssValue)")
    }
    
    public static func textDecorationLine(_ decoration: TextDecoration) -> Property {
      Property("text-decoration-line: \(decoration.cssValue)")
    }
    
    public static func textDecorationColor(_ color: Color) -> Property {
      Property("text-decoration-color: \(color.cssValue)")
    }
    
    public static func textDecorationStyle(_ value: String) -> Property {
      Property("text-decoration-style: \(value)")
    }
    
    public static func textDecorationThickness(_ unit: Unit) -> Property {
      Property("text-decoration-thickness: \(unit.cssValue)")
    }
    
    public static func textIndent(_ unit: Unit) -> Property {
      Property("text-indent: \(unit.cssValue)")
    }
    
    public static func textTransform(_ transform: TextTransform) -> Property {
      Property("text-transform: \(transform.cssValue)")
    }
    
    public static func textShadow(_ value: String) -> Property {
      Property("text-shadow: \(value)")
    }
    
    public static func textOverflow(_ value: String) -> Property {
      Property("text-overflow: \(value)")
    }
    
    public static func whiteSpace(_ space: WhiteSpace) -> Property {
      Property("white-space: \(space.cssValue)")
    }
    
    public static func wordBreak(_ break_: WordBreak) -> Property {
      Property("word-break: \(break_.cssValue)")
    }
    
    public static func verticalAlign(_ value: String) -> Property {
      Property("vertical-align: \(value)")
    }
    
    // MARK: - Background
    public static func background(_ value: String) -> Property {
      Property("background: \(value)")
    }
    
    public static func backgroundColor(_ color: Color) -> Property {
      Property("background-color: \(color.cssValue)")
    }
    
    public static func backgroundImage(_ value: String) -> Property {
      Property("background-image: \(value)")
    }
    
    public static func backgroundPosition(_ value: String) -> Property {
      Property("background-position: \(value)")
    }
    
    public static func backgroundSize(_ value: String) -> Property {
      Property("background-size: \(value)")
    }
    
    public static func backgroundRepeat(_ value: String) -> Property {
      Property("background-repeat: \(value)")
    }
    
    public static func backgroundOrigin(_ value: String) -> Property {
      Property("background-origin: \(value)")
    }
    
    public static func backgroundClip(_ value: String) -> Property {
      Property("background-clip: \(value)")
    }
    
    public static func backgroundAttachment(_ value: String) -> Property {
      Property("background-attachment: \(value)")
    }
    
    public static func backgroundBlendMode(_ value: String) -> Property {
      Property("background-blend-mode: \(value)")
    }
    
    // MARK: - Transform & Animation
    public static func transform(_ value: String) -> Property {
      Property("transform: \(value)")
    }
    
    public static func transformOrigin(_ value: String) -> Property {
      Property("transform-origin: \(value)")
    }
    
    public static func transformStyle(_ value: String) -> Property {
      Property("transform-style: \(value)")
    }
    
    public static func perspective(_ unit: Unit) -> Property {
      Property("perspective: \(unit.cssValue)")
    }
    
    public static func perspectiveOrigin(_ value: String) -> Property {
      Property("perspective-origin: \(value)")
    }
    
    public static func backfaceVisibility(_ value: String) -> Property {
      Property("backface-visibility: \(value)")
    }
    
    public static func transition(_ value: String) -> Property {
      Property("transition: \(value)")
    }
    
    public static func transitionProperty(_ value: String) -> Property {
      Property("transition-property: \(value)")
    }
    
    public static func transitionDuration(_ value: String) -> Property {
      Property("transition-duration: \(value)")
    }
    
    public static func transitionTimingFunction(_ value: String) -> Property {
      Property("transition-timing-function: \(value)")
    }
    
    public static func transitionDelay(_ value: String) -> Property {
      Property("transition-delay: \(value)")
    }
    
    public static func animation(_ value: String) -> Property {
      Property("animation: \(value)")
    }
    
    public static func animationName(_ value: String) -> Property {
      Property("animation-name: \(value)")
    }
    
    public static func animationDuration(_ value: String) -> Property {
      Property("animation-duration: \(value)")
    }
    
    public static func animationTimingFunction(_ value: String) -> Property {
      Property("animation-timing-function: \(value)")
    }
    
    public static func animationDelay(_ value: String) -> Property {
      Property("animation-delay: \(value)")
    }
    
    public static func animationIterationCount(_ value: String) -> Property {
      Property("animation-iteration-count: \(value)")
    }
    
    public static func animationDirection(_ value: String) -> Property {
      Property("animation-direction: \(value)")
    }
    
    public static func animationFillMode(_ value: String) -> Property {
      Property("animation-fill-mode: \(value)")
    }
    
    public static func animationPlayState(_ value: String) -> Property {
      Property("animation-play-state: \(value)")
    }
    
    // MARK: - Effects
    public static func boxShadow(_ value: String) -> Property {
      Property("box-shadow: \(value)")
    }
    
    public static func filter(_ value: String) -> Property {
      Property("filter: \(value)")
    }
    
    public static func backdropFilter(_ value: String) -> Property {
      Property("backdrop-filter: \(value)")
    }
    
    public static func mixBlendMode(_ value: String) -> Property {
      Property("mix-blend-mode: \(value)")
    }
    
    public static func clipPath(_ value: String) -> Property {
      Property("clip-path: \(value)")
    }
    
    public static func mask(_ value: String) -> Property {
      Property("mask: \(value)")
    }
    
    public static func maskImage(_ value: String) -> Property {
      Property("mask-image: \(value)")
    }
    
    public static func maskMode(_ value: String) -> Property {
      Property("mask-mode: \(value)")
    }
    
    public static func maskRepeat(_ value: String) -> Property {
      Property("mask-repeat: \(value)")
    }
    
    public static func maskPosition(_ value: String) -> Property {
      Property("mask-position: \(value)")
    }
    
    public static func maskClip(_ value: String) -> Property {
      Property("mask-clip: \(value)")
    }
    
    public static func maskOrigin(_ value: String) -> Property {
      Property("mask-origin: \(value)")
    }
    
    public static func maskSize(_ value: String) -> Property {
      Property("mask-size: \(value)")
    }
    
    // MARK: - Lists
    public static func listStyle(_ value: String) -> Property {
      Property("list-style: \(value)")
    }
    
    public static func listStyleType(_ type: ListStyleType) -> Property {
      Property("list-style-type: \(type.cssValue)")
    }
    
    public static func listStylePosition(_ position: ListStylePosition) -> Property {
      Property("list-style-position: \(position.cssValue)")
    }
    
    public static func listStyleImage(_ value: String) -> Property {
      Property("list-style-image: \(value)")
    }
    
    // MARK: - Tables
    public static func tableLayout(_ value: String) -> Property {
      Property("table-layout: \(value)")
    }
    
    public static func borderCollapse(_ value: String) -> Property {
      Property("border-collapse: \(value)")
    }
    
    public static func borderSpacing(_ value: String) -> Property {
      Property("border-spacing: \(value)")
    }
    
    public static func captionSide(_ value: String) -> Property {
      Property("caption-side: \(value)")
    }
    
    public static func emptyCells(_ value: String) -> Property {
      Property("empty-cells: \(value)")
    }
    
    // MARK: - Content
    public static func content(_ value: String) -> Property {
      Property("content: \(value)")
    }
    
    public static func quotes(_ value: String) -> Property {
      Property("quotes: \(value)")
    }
    
    public static func counterIncrement(_ value: String) -> Property {
      Property("counter-increment: \(value)")
    }
    
    public static func counterReset(_ value: String) -> Property {
      Property("counter-reset: \(value)")
    }
    
    public static func counterSet(_ value: String) -> Property {
      Property("counter-set: \(value)")
    }
    
    // MARK: - Cursor & Pointer
    public static func cursor(_ cursor: Cursor) -> Property {
      Property("cursor: \(cursor.cssValue)")
    }
    
    public static func pointerEvents(_ events: PointerEvents) -> Property {
      Property("pointer-events: \(events.cssValue)")
    }
    
    public static func userSelect(_ select: UserSelect) -> Property {
      Property("user-select: \(select.cssValue)")
    }
    
    public static func touchAction(_ value: String) -> Property {
      Property("touch-action: \(value)")
    }
    
    public static func resize(_ value: String) -> Property {
      Property("resize: \(value)")
    }
    
    // MARK: - Scroll
    public static func scrollBehavior(_ value: String) -> Property {
      Property("scroll-behavior: \(value)")
    }
    
    public static func scrollMargin(_ box: Box) -> Property {
      Property("scroll-margin: \(box.cssValue)")
    }
    
    public static func scrollPadding(_ box: Box) -> Property {
      Property("scroll-padding: \(box.cssValue)")
    }
    
    public static func scrollSnapAlign(_ value: String) -> Property {
      Property("scroll-snap-align: \(value)")
    }
    
    public static func scrollSnapStop(_ value: String) -> Property {
      Property("scroll-snap-stop: \(value)")
    }
    
    public static func scrollSnapType(_ value: String) -> Property {
      Property("scroll-snap-type: \(value)")
    }
    
    public static func overscrollBehavior(_ value: String) -> Property {
      Property("overscroll-behavior: \(value)")
    }
    
    public static func overscrollBehaviorX(_ value: String) -> Property {
      Property("overscroll-behavior-x: \(value)")
    }
    
    public static func overscrollBehaviorY(_ value: String) -> Property {
      Property("overscroll-behavior-y: \(value)")
    }
    
    // MARK: - Multi-column
    public static func columns(_ value: String) -> Property {
      Property("columns: \(value)")
    }
    
    public static func columnCount(_ value: Int) -> Property {
      Property("column-count: \(value)")
    }
    
    public static func columnWidth(_ unit: Unit) -> Property {
      Property("column-width: \(unit.cssValue)")
    }
    
    public static func columnRule(_ value: String) -> Property {
      Property("column-rule: \(value)")
    }
    
    public static func columnRuleWidth(_ unit: Unit) -> Property {
      Property("column-rule-width: \(unit.cssValue)")
    }
    
    public static func columnRuleStyle(_ style: BorderStyle) -> Property {
      Property("column-rule-style: \(style.cssValue)")
    }
    
    public static func columnRuleColor(_ color: Color) -> Property {
      Property("column-rule-color: \(color.cssValue)")
    }
    
    public static func columnSpan(_ value: String) -> Property {
      Property("column-span: \(value)")
    }
    
    public static func columnFill(_ value: String) -> Property {
      Property("column-fill: \(value)")
    }
    
    public static func breakBefore(_ value: String) -> Property {
      Property("break-before: \(value)")
    }
    
    public static func breakAfter(_ value: String) -> Property {
      Property("break-after: \(value)")
    }
    
    public static func breakInside(_ value: String) -> Property {
      Property("break-inside: \(value)")
    }
    
    // MARK: - Writing Modes
    public static func writingMode(_ value: String) -> Property {
      Property("writing-mode: \(value)")
    }
    
    public static func direction(_ value: String) -> Property {
      Property("direction: \(value)")
    }
    
    public static func textOrientation(_ value: String) -> Property {
      Property("text-orientation: \(value)")
    }
    
    public static func unicodeBidi(_ value: String) -> Property {
      Property("unicode-bidi: \(value)")
    }
    
    // MARK: - Other
    public static func float(_ value: String) -> Property {
      Property("float: \(value)")
    }
    
    public static func clear(_ value: String) -> Property {
      Property("clear: \(value)")
    }
    
    public static func objectFit(_ fit: ObjectFit) -> Property {
      Property("object-fit: \(fit.cssValue)")
    }
    
    public static func objectPosition(_ value: String) -> Property {
      Property("object-position: \(value)")
    }
    
    public static func isolation(_ value: String) -> Property {
      Property("isolation: \(value)")
    }
    
    public static func willChange(_ value: String) -> Property {
      Property("will-change: \(value)")
    }
    
    public static func contain(_ value: String) -> Property {
      Property("contain: \(value)")
    }
    
    public static func appearance(_ value: String) -> Property {
      Property("appearance: \(value)")
    }
    
    // MARK: - Custom & Raw
    public static func custom(name: String, value: String) -> Property {
      Property("\(name): \(value)")
    }
    
    public static func raw(_ value: String) -> Property {
      Property(value)
    }
    
    public init(stringLiteral value: String) {
      self = .raw(value)
    }
  }
}
