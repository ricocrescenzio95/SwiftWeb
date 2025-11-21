extension CSS {
  public struct Body: Sendable, Hashable, Codable {
    public var properties: [Property]
    
    public init(_ properties: [Property]) {
      self.properties = properties
    }
    
    public var css: String {
      properties.lazy.map { $0.css + ";" }.joined(separator: "\n  ")
    }
  }
}

extension CSS {
  public struct Property: Sendable, Hashable, Codable, ExpressibleByStringLiteral {
    public let name: String
    public let value: String
    public let css: String
    
    public init(rawCSS css: String) {
      name = "##raw"
      value = "##raw"
      self.css = css
    }
    
    public init(name: String, value: String) {
      self.name = name
      self.value = value
      css = "\(name): \(value)"
    }
    
    public init(stringLiteral rawCSS: String) {
      self.init(rawCSS: rawCSS)
    }
  }
}


// MARK: - CSS.Box Model - Margin
@inlinable public func margin(_ box: CSS.Box) -> CSS.Property {
  .init(name: "margin", value: "\(box.css)")
}

@inlinable public func marginBlock(_ unit: CSS.Unit) -> CSS.Property {
  .init(name: "margin-block", value: "\(unit.css)")
}

@inlinable public func marginBlockStart(_ unit: CSS.Unit) -> CSS.Property {
  .init(name: "margin-block-start", value: "\(unit.css)")
}

@inlinable public func marginBlockEnd(_ unit: CSS.Unit) -> CSS.Property {
  .init(name: "margin-block-end", value: "\(unit.css)")
}

@inlinable public func marginInline(_ unit: CSS.Unit) -> CSS.Property {
  .init(name: "margin-inline", value: "\(unit.css)")
}

@inlinable public func marginInlineStart(_ unit: CSS.Unit) -> CSS.Property {
  .init(name: "margin-inline-start", value: "\(unit.css)")
}

@inlinable public func marginInlineEnd(_ unit: CSS.Unit) -> CSS.Property {
  .init(name: "margin-inline-end", value: "\(unit.css)")
}

// MARK: - CSS.Box Model - Padding
@inlinable public func padding(_ box: CSS.Box) -> CSS.Property {
  .init(name: "padding", value: "\(box.css)")
}

@inlinable public func paddingBlock(_ unit: CSS.Unit) -> CSS.Property {
  .init(name: "padding-block", value: "\(unit.css)")
}

@inlinable public func paddingBlockStart(_ unit: CSS.Unit) -> CSS.Property {
  .init(name: "padding-block-start", value: "\(unit.css)")
}

@inlinable public func paddingBlockEnd(_ unit: CSS.Unit) -> CSS.Property {
  .init(name: "padding-block-end", value: "\(unit.css)")
}

@inlinable public func paddingInline(_ unit: CSS.Unit) -> CSS.Property {
  .init(name: "padding-inline", value: "\(unit.css)")
}

@inlinable public func paddingInlineStart(_ unit: CSS.Unit) -> CSS.Property {
  .init(name: "padding-inline-start", value: "\(unit.css)")
}

@inlinable public func paddingInlineEnd(_ unit: CSS.Unit) -> CSS.Property {
  .init(name: "padding-inline-end", value: "\(unit.css)")
}

// MARK: - CSS.Box Model - Border
@inlinable public func border(_ value: String) -> CSS.Property {
  .init(name: "border", value: "\(value)")
}

@inlinable public func borderWidth(_ box: CSS.Box) -> CSS.Property {
  .init(name: "border-width", value: "\(box.css)")
}

@inlinable public func borderStyle(_ style: CSS.BorderStyle) -> CSS.Property {
  .init(name: "border-style", value: "\(style.css)")
}

@inlinable public func borderColor(_ color: CSS.Color) -> CSS.Property {
  .init(name: "border-color", value: "\(color.css)")
}

@inlinable public func borderTop(_ value: String) -> CSS.Property {
  .init(name: "border-top", value: "\(value)")
}

@inlinable public func borderRight(_ value: String) -> CSS.Property {
  .init(name: "border-right", value: "\(value)")
}

@inlinable public func borderBottom(_ value: String) -> CSS.Property {
  .init(name: "border-bottom", value: "\(value)")
}

@inlinable public func borderLeft(_ value: String) -> CSS.Property {
  .init(name: "border-left", value: "\(value)")
}

@inlinable public func borderRadius(_ box: CSS.Box) -> CSS.Property {
  .init(name: "border-radius", value: "\(box.css)")
}

// MARK: - CSS.Box Model - Outline
@inlinable public func outline(_ value: String) -> CSS.Property {
  .init(name: "outline", value: "\(value)")
}

@inlinable public func outlineWidth(_ unit: CSS.Unit) -> CSS.Property {
  .init(name: "outline-width", value: "\(unit.css)")
}

@inlinable public func outlineStyle(_ style: CSS.BorderStyle) -> CSS.Property {
  .init(name: "outline-style", value: "\(style.css)")
}

@inlinable public func outlineColor(_ color: CSS.Color) -> CSS.Property {
  .init(name: "outline-color", value: "\(color.css)")
}

@inlinable public func outlineOffset(_ unit: CSS.Unit) -> CSS.Property {
  .init(name: "outline-offset", value: "\(unit.css)")
}

// MARK: - Dimensions
@inlinable public func width(_ unit: CSS.Unit) -> CSS.Property {
  .init(name: "width", value: "\(unit.css)")
}

@inlinable public func height(_ unit: CSS.Unit) -> CSS.Property {
  .init(name: "height", value: "\(unit.css)")
}

@inlinable public func minWidth(_ unit: CSS.Unit) -> CSS.Property {
  .init(name: "min-width", value: "\(unit.css)")
}

@inlinable public func minHeight(_ unit: CSS.Unit) -> CSS.Property {
  .init(name: "min-height", value: "\(unit.css)")
}

@inlinable public func maxWidth(_ unit: CSS.Unit) -> CSS.Property {
  .init(name: "max-width", value: "\(unit.css)")
}

@inlinable public func maxHeight(_ unit: CSS.Unit) -> CSS.Property {
  .init(name: "max-height", value: "\(unit.css)")
}

@inlinable public func boxSizing(_ sizing: CSS.BoxSizing) -> CSS.Property {
  .init(name: "box-sizing", value: "\(sizing.css)")
}

@inlinable public func aspectRatio(_ value: String) -> CSS.Property {
  .init(name: "aspect-ratio", value: "\(value)")
}

// MARK: - Display & Visibility
@inlinable public func display(_ display: CSS.Display) -> CSS.Property {
  .init(name: "display", value: "\(display.css)")
}

@inlinable public func visibility(_ visibility: CSS.Visibility) -> CSS.Property {
  .init(name: "visibility", value: "\(visibility.css)")
}

@inlinable public func opacity(_ value: Double) -> CSS.Property {
  .init(name: "opacity", value: "\(value)")
}

@inlinable public func overflow(_ overflow: CSS.Overflow) -> CSS.Property {
  .init(name: "overflow", value: "\(overflow.css)")
}

@inlinable public func overflowX(_ overflow: CSS.Overflow) -> CSS.Property {
  .init(name: "overflow-x", value: "\(overflow.css)")
}

@inlinable public func overflowY(_ overflow: CSS.Overflow) -> CSS.Property {
  .init(name: "overflow-y", value: "\(overflow.css)")
}

@inlinable public func overflowWrap(_ value: String) -> CSS.Property {
  .init(name: "overflow-wrap", value: "\(value)")
}

// MARK: - Position
@inlinable public func position(_ position: CSS.Position) -> CSS.Property {
  .init(name: "position", value: "\(position.css)")
}

@inlinable public func inset(_ box: CSS.Box) -> CSS.Property {
  .init(name: "inset", value: "\(box.css)")
}

@inlinable public func insetBlock(_ unit: CSS.Unit) -> CSS.Property {
  .init(name: "inset-block", value: "\(unit.css)")
}

@inlinable public func insetInline(_ unit: CSS.Unit) -> CSS.Property {
  .init(name: "inset-inline", value: "\(unit.css)")
}

@inlinable public func zIndex(_ value: Int) -> CSS.Property {
  .init(name: "z-index", value: "\(value)")
}

// MARK: - Flexbox
@inlinable public func flexDirection(_ direction: CSS.FlexDirection) -> CSS.Property {
  .init(name: "flex-direction", value: "\(direction.css)")
}

@inlinable public func flexWrap(_ wrap: CSS.FlexWrap) -> CSS.Property {
  .init(name: "flex-wrap", value: "\(wrap.css)")
}

@inlinable public func flexFlow(_ value: String) -> CSS.Property {
  .init(name: "flex-flow", value: "\(value)")
}

@inlinable public func justifyContent(_ justify: CSS.JustifyContent) -> CSS.Property {
  .init(name: "justify-content", value: "\(justify.css)")
}

@inlinable public func alignItems(_ align: CSS.AlignItems) -> CSS.Property {
  .init(name: "align-items", value: "\(align.css)")
}

@inlinable public func alignContent(_ align: CSS.AlignContent) -> CSS.Property {
  .init(name: "align-content", value: "\(align.css)")
}

@inlinable public func alignSelf(_ align: CSS.AlignItems) -> CSS.Property {
  .init(name: "align-self", value: "\(align.css)")
}

@inlinable public func flex(_ value: String) -> CSS.Property {
  .init(name: "flex", value: "\(value)")
}

@inlinable public func flexGrow(_ value: Double) -> CSS.Property {
  .init(name: "flex-grow", value: "\(value)")
}

@inlinable public func flexShrink(_ value: Double) -> CSS.Property {
  .init(name: "flex-shrink", value: "\(value)")
}

@inlinable public func flexBasis(_ unit: CSS.Unit) -> CSS.Property {
  .init(name: "flex-basis", value: "\(unit.css)")
}

@inlinable public func order(_ value: Int) -> CSS.Property {
  .init(name: "order", value: "\(value)")
}

@inlinable public func gap(_ unit: CSS.Unit) -> CSS.Property {
  .init(name: "gap", value: "\(unit.css)")
}

@inlinable public func rowGap(_ unit: CSS.Unit) -> CSS.Property {
  .init(name: "row-gap", value: "\(unit.css)")
}

@inlinable public func columnGap(_ unit: CSS.Unit) -> CSS.Property {
  .init(name: "column-gap", value: "\(unit.css)")
}

// MARK: - Grid
@inlinable public func gridTemplateColumns(_ value: String) -> CSS.Property {
  .init(name: "grid-template-columns", value: "\(value)")
}

@inlinable public func gridTemplateRows(_ value: String) -> CSS.Property {
  .init(name: "grid-template-rows", value: "\(value)")
}

@inlinable public func gridTemplateAreas(_ value: String) -> CSS.Property {
  .init(name: "grid-template-areas", value: "\(value)")
}

@inlinable public func gridTemplate(_ value: String) -> CSS.Property {
  .init(name: "grid-template", value: "\(value)")
}

@inlinable public func gridAutoColumns(_ value: String) -> CSS.Property {
  .init(name: "grid-auto-columns", value: "\(value)")
}

@inlinable public func gridAutoRows(_ value: String) -> CSS.Property {
  .init(name: "grid-auto-rows", value: "\(value)")
}

@inlinable public func gridAutoFlow(_ value: String) -> CSS.Property {
  .init(name: "grid-auto-flow", value: "\(value)")
}

@inlinable public func gridColumn(_ value: String) -> CSS.Property {
  .init(name: "grid-column", value: "\(value)")
}

@inlinable public func gridColumnStart(_ value: String) -> CSS.Property {
  .init(name: "grid-column-start", value: "\(value)")
}

@inlinable public func gridColumnEnd(_ value: String) -> CSS.Property {
  .init(name: "grid-column-end", value: "\(value)")
}

@inlinable public func gridRow(_ value: String) -> CSS.Property {
  .init(name: "grid-row", value: "\(value)")
}

@inlinable public func gridRowStart(_ value: String) -> CSS.Property {
  .init(name: "grid-row-start", value: "\(value)")
}

@inlinable public func gridRowEnd(_ value: String) -> CSS.Property {
  .init(name: "grid-row-end", value: "\(value)")
}

@inlinable public func gridArea(_ value: String) -> CSS.Property {
  .init(name: "grid-area", value: "\(value)")
}

@inlinable public func justifyItems(_ justify: CSS.JustifyContent) -> CSS.Property {
  .init(name: "justify-items", value: "\(justify.css)")
}

@inlinable public func justifySelf(_ justify: CSS.JustifyContent) -> CSS.Property {
  .init(name: "justify-self", value: "\(justify.css)")
}

@inlinable public func placeItems(_ value: String) -> CSS.Property {
  .init(name: "place-items", value: "\(value)")
}

@inlinable public func placeContent(_ value: String) -> CSS.Property {
  .init(name: "place-content", value: "\(value)")
}

@inlinable public func placeSelf(_ value: String) -> CSS.Property {
  .init(name: "place-self", value: "\(value)")
}

// MARK: - Typography
@inlinable public func color(_ color: CSS.Color) -> CSS.Property {
  .init(name: "color", value: "\(color.css)")
}

@inlinable public func fontFamily(_ value: String) -> CSS.Property {
  .init(name: "font-family", value: "\(value)")
}

@inlinable public func fontSize(_ unit: CSS.Unit) -> CSS.Property {
  .init(name: "font-size", value: "\(unit.css)")
}

@inlinable public func fontWeight(_ weight: CSS.FontWeight) -> CSS.Property {
  .init(name: "font-weight", value: "\(weight.css)")
}

@inlinable public func fontStyle(_ style: CSS.FontStyle) -> CSS.Property {
  .init(name: "font-style", value: "\(style.css)")
}

@inlinable public func fontVariant(_ value: String) -> CSS.Property {
  .init(name: "font-variant", value: "\(value)")
}

@inlinable public func font(_ value: String) -> CSS.Property {
  .init(name: "font", value: "\(value)")
}

@inlinable public func lineHeight(_ unit: CSS.Unit) -> CSS.Property {
  .init(name: "line-height", value: "\(unit.css)")
}

@inlinable public func letterSpacing(_ unit: CSS.Unit) -> CSS.Property {
  .init(name: "letter-spacing", value: "\(unit.css)")
}

@inlinable public func wordSpacing(_ unit: CSS.Unit) -> CSS.Property {
  .init(name: "word-spacing", value: "\(unit.css)")
}

@inlinable public func textAlign(_ align: CSS.TextAlign) -> CSS.Property {
  .init(name: "text-align", value: "\(align.css)")
}

@inlinable public func textAlignLast(_ align: CSS.TextAlign) -> CSS.Property {
  .init(name: "text-align-last", value: "\(align.css)")
}

@inlinable public func textDecoration(_ decoration: CSS.TextDecoration) -> CSS.Property {
  .init(name: "text-decoration", value: "\(decoration.css)")
}

@inlinable public func textDecorationLine(_ decoration: CSS.TextDecoration) -> CSS.Property {
  .init(name: "text-decoration-line", value: "\(decoration.css)")
}

@inlinable public func textDecorationColor(_ color: CSS.Color) -> CSS.Property {
  .init(name: "text-decoration-color", value: "\(color.css)")
}

@inlinable public func textDecorationStyle(_ value: String) -> CSS.Property {
  .init(name: "text-decoration-style", value: "\(value)")
}

@inlinable public func textDecorationThickness(_ unit: CSS.Unit) -> CSS.Property {
  .init(name: "text-decoration-thickness", value: "\(unit.css)")
}

@inlinable public func textIndent(_ unit: CSS.Unit) -> CSS.Property {
  .init(name: "text-indent", value: "\(unit.css)")
}

@inlinable public func textTransform(_ transform: CSS.TextTransform) -> CSS.Property {
  .init(name: "text-transform", value: "\(transform.css)")
}

@inlinable public func textShadow(_ value: String) -> CSS.Property {
  .init(name: "text-shadow", value: "\(value)")
}

@inlinable public func textOverflow(_ value: String) -> CSS.Property {
  .init(name: "text-overflow", value: "\(value)")
}

@inlinable public func whiteSpace(_ space: CSS.WhiteSpace) -> CSS.Property {
  .init(name: "white-space", value: "\(space.css)")
}

@inlinable public func wordBreak(_ break_: CSS.WordBreak) -> CSS.Property {
  .init(name: "word-break", value: "\(break_.css)")
}

@inlinable public func verticalAlign(_ value: String) -> CSS.Property {
  .init(name: "vertical-align", value: "\(value)")
}

// MARK: - Background
@inlinable public func background(_ value: String) -> CSS.Property {
  .init(name: "background", value: "\(value)")
}

@inlinable public func backgroundColor(_ color: CSS.Color) -> CSS.Property {
  .init(name: "background-color", value: "\(color.css)")
}

@inlinable public func backgroundImage(_ value: String) -> CSS.Property {
  .init(name: "background-image", value: "\(value)")
}

@inlinable public func backgroundPosition(_ value: String) -> CSS.Property {
  .init(name: "background-position", value: "\(value)")
}

@inlinable public func backgroundSize(_ value: String) -> CSS.Property {
  .init(name: "background-size", value: "\(value)")
}

@inlinable public func backgroundRepeat(_ value: String) -> CSS.Property {
  .init(name: "background-repeat", value: "\(value)")
}

@inlinable public func backgroundOrigin(_ value: String) -> CSS.Property {
  .init(name: "background-origin", value: "\(value)")
}

@inlinable public func backgroundClip(_ value: String) -> CSS.Property {
  .init(name: "background-clip", value: "\(value)")
}

@inlinable public func backgroundAttachment(_ value: String) -> CSS.Property {
  .init(name: "background-attachment", value: "\(value)")
}

@inlinable public func backgroundBlendMode(_ value: String) -> CSS.Property {
  .init(name: "background-blend-mode", value: "\(value)")
}

// MARK: - Transform & Animation
@inlinable public func transform(_ value: String) -> CSS.Property {
  .init(name: "transform", value: "\(value)")
}

@inlinable public func transformOrigin(_ value: String) -> CSS.Property {
  .init(name: "transform-origin", value: "\(value)")
}

@inlinable public func transformStyle(_ value: String) -> CSS.Property {
  .init(name: "transform-style", value: "\(value)")
}

@inlinable public func perspective(_ unit: CSS.Unit) -> CSS.Property {
  .init(name: "perspective", value: "\(unit.css)")
}

@inlinable public func perspectiveOrigin(_ value: String) -> CSS.Property {
  .init(name: "perspective-origin", value: "\(value)")
}

@inlinable public func backfaceVisibility(_ value: String) -> CSS.Property {
  .init(name: "backface-visibility", value: "\(value)")
}

@inlinable public func transition(_ value: String) -> CSS.Property {
  .init(name: "transition", value: "\(value)")
}

@inlinable public func transitionProperty(_ value: String) -> CSS.Property {
  .init(name: "transition-property", value: "\(value)")
}

@inlinable public func transitionDuration(_ value: String) -> CSS.Property {
  .init(name: "transition-duration", value: "\(value)")
}

@inlinable public func transitionTimingFunction(_ value: String) -> CSS.Property {
  .init(name: "transition-timing-function", value: "\(value)")
}

@inlinable public func transitionDelay(_ value: String) -> CSS.Property {
  .init(name: "transition-delay", value: "\(value)")
}

@inlinable public func animation(_ value: String) -> CSS.Property {
  .init(name: "animation", value: "\(value)")
}

@inlinable public func animationName(_ value: String) -> CSS.Property {
  .init(name: "animation-name", value: "\(value)")
}

@inlinable public func animationDuration(_ value: String) -> CSS.Property {
  .init(name: "animation-duration", value: "\(value)")
}

@inlinable public func animationTimingFunction(_ value: String) -> CSS.Property {
  .init(name: "animation-timing-function", value: "\(value)")
}

@inlinable public func animationDelay(_ value: String) -> CSS.Property {
  .init(name: "animation-delay", value: "\(value)")
}

@inlinable public func animationIterationCount(_ value: String) -> CSS.Property {
  .init(name: "animation-iteration-count", value: "\(value)")
}

@inlinable public func animationDirection(_ value: String) -> CSS.Property {
  .init(name: "animation-direction", value: "\(value)")
}

@inlinable public func animationFillMode(_ value: String) -> CSS.Property {
  .init(name: "animation-fill-mode", value: "\(value)")
}

@inlinable public func animationPlayState(_ value: String) -> CSS.Property {
  .init(name: "animation-play-state", value: "\(value)")
}

// MARK: - Effects
@inlinable public func boxShadow(_ value: String) -> CSS.Property {
  .init(name: "box-shadow", value: "\(value)")
}

@inlinable public func filter(_ value: String) -> CSS.Property {
  .init(name: "filter", value: "\(value)")
}

@inlinable public func backdropFilter(_ value: String) -> CSS.Property {
  .init(name: "backdrop-filter", value: "\(value)")
}

@inlinable public func mixBlendMode(_ value: String) -> CSS.Property {
  .init(name: "mix-blend-mode", value: "\(value)")
}

@inlinable public func clipPath(_ value: String) -> CSS.Property {
  .init(name: "clip-path", value: "\(value)")
}

@inlinable public func mask(_ value: String) -> CSS.Property {
  .init(name: "mask", value: "\(value)")
}

@inlinable public func maskImage(_ value: String) -> CSS.Property {
  .init(name: "mask-image", value: "\(value)")
}

@inlinable public func maskMode(_ value: String) -> CSS.Property {
  .init(name: "mask-mode", value: "\(value)")
}

@inlinable public func maskRepeat(_ value: String) -> CSS.Property {
  .init(name: "mask-repeat", value: "\(value)")
}

@inlinable public func maskPosition(_ value: String) -> CSS.Property {
  .init(name: "mask-position", value: "\(value)")
}

@inlinable public func maskClip(_ value: String) -> CSS.Property {
  .init(name: "mask-clip", value: "\(value)")
}

@inlinable public func maskOrigin(_ value: String) -> CSS.Property {
  .init(name: "mask-origin", value: "\(value)")
}

@inlinable public func maskSize(_ value: String) -> CSS.Property {
  .init(name: "mask-size", value: "\(value)")
}

// MARK: - Lists
@inlinable public func listStyle(_ value: String) -> CSS.Property {
  .init(name: "list-style", value: "\(value)")
}

@inlinable public func listStyleType(_ type: CSS.ListStyleType) -> CSS.Property {
  .init(name: "list-style-type", value: "\(type.css)")
}

@inlinable public func listStylePosition(_ position: CSS.ListStylePosition) -> CSS.Property {
  .init(name: "list-style-position", value: "\(position.css)")
}

@inlinable public func listStyleImage(_ value: String) -> CSS.Property {
  .init(name: "list-style-image", value: "\(value)")
}

// MARK: - Tables
@inlinable public func tableLayout(_ value: String) -> CSS.Property {
  .init(name: "table-layout", value: "\(value)")
}

@inlinable public func borderCollapse(_ value: String) -> CSS.Property {
  .init(name: "border-collapse", value: "\(value)")
}

@inlinable public func borderSpacing(_ value: String) -> CSS.Property {
  .init(name: "border-spacing", value: "\(value)")
}

@inlinable public func captionSide(_ value: String) -> CSS.Property {
  .init(name: "caption-side", value: "\(value)")
}

@inlinable public func emptyCells(_ value: String) -> CSS.Property {
  .init(name: "empty-cells", value: "\(value)")
}

// MARK: - Content
@inlinable public func content(_ value: String) -> CSS.Property {
  .init(name: "content", value: "\(value)")
}

@inlinable public func quotes(_ value: String) -> CSS.Property {
  .init(name: "quotes", value: "\(value)")
}

@inlinable public func counterIncrement(_ value: String) -> CSS.Property {
  .init(name: "counter-increment", value: "\(value)")
}

@inlinable public func counterReset(_ value: String) -> CSS.Property {
  .init(name: "counter-reset", value: "\(value)")
}

@inlinable public func counterSet(_ value: String) -> CSS.Property {
  .init(name: "counter-set", value: "\(value)")
}

// MARK: - Cursor & Pointer
@inlinable public func cursor(_ cursor: CSS.Cursor) -> CSS.Property {
  .init(name: "cursor", value: "\(cursor.css)")
}

@inlinable public func pointerEvents(_ events: CSS.PointerEvents) -> CSS.Property {
  .init(name: "pointer-events", value: "\(events.css)")
}

@inlinable public func userSelect(_ select: CSS.UserSelect) -> CSS.Property {
  .init(name: "user-select", value: "\(select.css)")
}

@inlinable public func touchAction(_ value: String) -> CSS.Property {
  .init(name: "touch-action", value: "\(value)")
}

@inlinable public func resize(_ value: String) -> CSS.Property {
  .init(name: "resize", value: "\(value)")
}

// MARK: - Scroll
@inlinable public func scrollBehavior(_ value: String) -> CSS.Property {
  .init(name: "scroll-behavior", value: "\(value)")
}

@inlinable public func scrollMargin(_ box: CSS.Box) -> CSS.Property {
  .init(name: "scroll-margin", value: "\(box.css)")
}

@inlinable public func scrollPadding(_ box: CSS.Box) -> CSS.Property {
  .init(name: "scroll-padding", value: "\(box.css)")
}

@inlinable public func scrollSnapAlign(_ value: String) -> CSS.Property {
  .init(name: "scroll-snap-align", value: "\(value)")
}

@inlinable public func scrollSnapStop(_ value: String) -> CSS.Property {
  .init(name: "scroll-snap-stop", value: "\(value)")
}

@inlinable public func scrollSnapType(_ value: String) -> CSS.Property {
  .init(name: "scroll-snap-type", value: "\(value)")
}

@inlinable public func overscrollBehavior(_ value: String) -> CSS.Property {
  .init(name: "overscroll-behavior", value: "\(value)")
}

@inlinable public func overscrollBehaviorX(_ value: String) -> CSS.Property {
  .init(name: "overscroll-behavior-x", value: "\(value)")
}

@inlinable public func overscrollBehaviorY(_ value: String) -> CSS.Property {
  .init(name: "overscroll-behavior-y", value: "\(value)")
}

// MARK: - Multi-column
@inlinable public func columns(_ value: String) -> CSS.Property {
  .init(name: "columns", value: "\(value)")
}

@inlinable public func columnCount(_ value: Int) -> CSS.Property {
  .init(name: "column-count", value: "\(value)")
}

@inlinable public func columnWidth(_ unit: CSS.Unit) -> CSS.Property {
  .init(name: "column-width", value: "\(unit.css)")
}

@inlinable public func columnRule(_ value: String) -> CSS.Property {
  .init(name: "column-rule", value: "\(value)")
}

@inlinable public func columnRuleWidth(_ unit: CSS.Unit) -> CSS.Property {
  .init(name: "column-rule-width", value: "\(unit.css)")
}

@inlinable public func columnRuleStyle(_ style: CSS.BorderStyle) -> CSS.Property {
  .init(name: "column-rule-style", value: "\(style.css)")
}

@inlinable public func columnRuleColor(_ color: CSS.Color) -> CSS.Property {
  .init(name: "column-rule-color", value: "\(color.css)")
}

@inlinable public func columnSpan(_ value: String) -> CSS.Property {
  .init(name: "column-span", value: "\(value)")
}

@inlinable public func columnFill(_ value: String) -> CSS.Property {
  .init(name: "column-fill", value: "\(value)")
}

@inlinable public func breakBefore(_ value: String) -> CSS.Property {
  .init(name: "break-before", value: "\(value)")
}

@inlinable public func breakAfter(_ value: String) -> CSS.Property {
  .init(name: "break-after", value: "\(value)")
}

@inlinable public func breakInside(_ value: String) -> CSS.Property {
  .init(name: "break-inside", value: "\(value)")
}

// MARK: - Writing Modes
@inlinable public func writingMode(_ value: String) -> CSS.Property {
  .init(name: "writing-mode", value: "\(value)")
}

@inlinable public func direction(_ value: String) -> CSS.Property {
  .init(name: "direction", value: "\(value)")
}

@inlinable public func textOrientation(_ value: String) -> CSS.Property {
  .init(name: "text-orientation", value: "\(value)")
}

@inlinable public func unicodeBidi(_ value: String) -> CSS.Property {
  .init(name: "unicode-bidi", value: "\(value)")
}

// MARK: - Other
@inlinable public func float(_ value: String) -> CSS.Property {
  .init(name: "float", value: "\(value)")
}

@inlinable public func clear(_ value: String) -> CSS.Property {
  .init(name: "clear", value: "\(value)")
}

@inlinable public func objectFit(_ fit: CSS.ObjectFit) -> CSS.Property {
  .init(name: "object-fit", value: "\(fit.css)")
}

@inlinable public func objectPosition(_ value: String) -> CSS.Property {
  .init(name: "object-position", value: "\(value)")
}

@inlinable public func isolation(_ value: String) -> CSS.Property {
  .init(name: "isolation", value: "\(value)")
}

@inlinable public func willChange(_ value: String) -> CSS.Property {
  .init(name: "will-change", value: "\(value)")
}

@inlinable public func contain(_ value: String) -> CSS.Property {
  .init(name: "contain", value: "\(value)")
}

@inlinable public func appearance(_ value: String) -> CSS.Property {
  .init(name: "appearance", value: "\(value)")
}
