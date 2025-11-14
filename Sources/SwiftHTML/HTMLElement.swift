public struct HTMLElement<AttributesType, Content: Node>: Node {
  public var name: String
  public var attributes: [HTMLAttribute<AttributesType>]
  public var content: Content
  
  fileprivate init(
    name: String,
    attributes: [HTMLAttribute<AttributesType>],
    content: Content
  ) {
    self.name = name
    self.attributes = attributes
    self.content = content
  }
}

// MARK: - API

public struct rawHTML: Node {
  public var content: some Node { _EmptyNode() }
  public let raw: String
  
  public init(_ raw: String) {
    self.raw = raw
  }
}

// MARK: - Document Metadata

public func head(_ attributes: HTMLAttribute<Void>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<Void, some Node> {
  .init(name: "head", attributes: attributes, content: content())
}

public func title(_ attributes: HTMLAttribute<Void>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<Void, some Node> {
  .init(name: "title", attributes: attributes, content: content())
}

public func base(_ attributes: HTMLAttribute<Void>...) -> HTMLElement<Void, some Node> {
  .init(name: "base", attributes: attributes, content: _EmptyNode())
}

public func link(_ attributes: HTMLAttribute<LinkElement>...) -> HTMLElement<LinkElement, some Node> {
  .init(name: "link", attributes: attributes, content: _EmptyNode())
}

public func meta(_ attributes: HTMLAttribute<Void>...) -> HTMLElement<Void, some Node> {
  .init(name: "meta", attributes: attributes, content: _EmptyNode())
}

public func style(_ attributes: HTMLAttribute<Void>..., @CSS content: () -> [CSS.Selector]) -> HTMLElement<Void, some Node> {
  .init(name: "style", attributes: attributes, content: content().lazy.map(\.cssValue).joined(separator: "\n"))
}

// MARK: - Sectioning Root

public func body(_ attributes: HTMLAttribute<Void>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<Void, some Node> {
  .init(name: "body", attributes: attributes, content: content())
}

// MARK: - Content Sectioning

public func address(_ attributes: HTMLAttribute<Void>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<Void, some Node> {
  .init(name: "address", attributes: attributes, content: content())
}

public func article(_ attributes: HTMLAttribute<Void>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<Void, some Node> {
  .init(name: "article", attributes: attributes, content: content())
}

public func aside(_ attributes: HTMLAttribute<Void>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<Void, some Node> {
  .init(name: "aside", attributes: attributes, content: content())
}

public func footer(_ attributes: HTMLAttribute<Void>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<Void, some Node> {
  .init(name: "footer", attributes: attributes, content: content())
}

public func header(_ attributes: HTMLAttribute<Void>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<Void, some Node> {
  .init(name: "header", attributes: attributes, content: content())
}

public func h1(_ attributes: HTMLAttribute<Void>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<Void, some Node> {
  .init(name: "h1", attributes: attributes, content: content())
}

public func h2(_ attributes: HTMLAttribute<Void>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<Void, some Node> {
  .init(name: "h2", attributes: attributes, content: content())
}

public func h3(_ attributes: HTMLAttribute<Void>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<Void, some Node> {
  .init(name: "h3", attributes: attributes, content: content())
}

public func h4(_ attributes: HTMLAttribute<Void>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<Void, some Node> {
  .init(name: "h4", attributes: attributes, content: content())
}

public func h5(_ attributes: HTMLAttribute<Void>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<Void, some Node> {
  .init(name: "h5", attributes: attributes, content: content())
}

public func h6(_ attributes: HTMLAttribute<Void>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<Void, some Node> {
  .init(name: "h6", attributes: attributes, content: content())
}

public func hgroup(_ attributes: HTMLAttribute<Void>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<Void, some Node> {
  .init(name: "hgroup", attributes: attributes, content: content())
}

public func main(_ attributes: HTMLAttribute<Void>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<Void, some Node> {
  .init(name: "main", attributes: attributes, content: content())
}

public func nav(_ attributes: HTMLAttribute<Void>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<Void, some Node> {
  .init(name: "nav", attributes: attributes, content: content())
}

public func section(_ attributes: HTMLAttribute<Void>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<Void, some Node> {
  .init(name: "section", attributes: attributes, content: content())
}

public func search(_ attributes: HTMLAttribute<Void>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<Void, some Node> {
  .init(name: "search", attributes: attributes, content: content())
}

// MARK: - Text Content

public func blockquote(_ attributes: HTMLAttribute<QuoteElement>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<QuoteElement, some Node> {
  .init(name: "blockquote", attributes: attributes, content: content())
}

public func dd(_ attributes: HTMLAttribute<Void>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<Void, some Node> {
  .init(name: "dd", attributes: attributes, content: content())
}

public func div(_ attributes: HTMLAttribute<Void>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<Void, some Node> {
  .init(name: "div", attributes: attributes, content: content())
}

public func dl(_ attributes: HTMLAttribute<Void>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<Void, some Node> {
  .init(name: "dl", attributes: attributes, content: content())
}

public func dt(_ attributes: HTMLAttribute<Void>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<Void, some Node> {
  .init(name: "dt", attributes: attributes, content: content())
}

public func figcaption(_ attributes: HTMLAttribute<Void>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<Void, some Node> {
  .init(name: "figcaption", attributes: attributes, content: content())
}

public func figure(_ attributes: HTMLAttribute<Void>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<Void, some Node> {
  .init(name: "figure", attributes: attributes, content: content())
}

public func hr(_ attributes: HTMLAttribute<Void>...) -> HTMLElement<Void, some Node> {
  .init(name: "hr", attributes: attributes, content: _EmptyNode())
}

public func li(_ attributes: HTMLAttribute<ListItemElement>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<ListItemElement, some Node> {
  .init(name: "li", attributes: attributes, content: content())
}

public func menu(_ attributes: HTMLAttribute<Void>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<Void, some Node> {
  .init(name: "menu", attributes: attributes, content: content())
}

public func ol(_ attributes: HTMLAttribute<OrderedListElement>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<OrderedListElement, some Node> {
  .init(name: "ol", attributes: attributes, content: content())
}

public func p(_ attributes: HTMLAttribute<Void>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<Void, some Node> {
  .init(name: "p", attributes: attributes, content: content())
}

public func pre(_ attributes: HTMLAttribute<Void>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<Void, some Node> {
  .init(name: "pre", attributes: attributes, content: content())
}

public func ul(_ attributes: HTMLAttribute<Void>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<Void, some Node> {
  .init(name: "ul", attributes: attributes, content: content())
}

// MARK: - Inline Text Semantics

public func a(_ attributes: HTMLAttribute<LinkElement>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<LinkElement, some Node> {
  .init(name: "a", attributes: attributes, content: content())
}

public func abbr(_ attributes: HTMLAttribute<Void>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<Void, some Node> {
  .init(name: "abbr", attributes: attributes, content: content())
}

public func b(_ attributes: HTMLAttribute<Void>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<Void, some Node> {
  .init(name: "b", attributes: attributes, content: content())
}

public func bdi(_ attributes: HTMLAttribute<Void>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<Void, some Node> {
  .init(name: "bdi", attributes: attributes, content: content())
}

public func bdo(_ attributes: HTMLAttribute<Void>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<Void, some Node> {
  .init(name: "bdo", attributes: attributes, content: content())
}

public func br(_ attributes: HTMLAttribute<Void>...) -> HTMLElement<Void, some Node> {
  .init(name: "br", attributes: attributes, content: _EmptyNode())
}

public func cite(_ attributes: HTMLAttribute<Void>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<Void, some Node> {
  .init(name: "cite", attributes: attributes, content: content())
}

public func code(_ attributes: HTMLAttribute<Void>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<Void, some Node> {
  .init(name: "code", attributes: attributes, content: content())
}

public func data(_ attributes: HTMLAttribute<DataElement>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<DataElement, some Node> {
  .init(name: "data", attributes: attributes, content: content())
}

public func dfn(_ attributes: HTMLAttribute<Void>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<Void, some Node> {
  .init(name: "dfn", attributes: attributes, content: content())
}

public func em(_ attributes: HTMLAttribute<Void>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<Void, some Node> {
  .init(name: "em", attributes: attributes, content: content())
}

public func i(_ attributes: HTMLAttribute<Void>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<Void, some Node> {
  .init(name: "i", attributes: attributes, content: content())
}

public func kbd(_ attributes: HTMLAttribute<Void>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<Void, some Node> {
  .init(name: "kbd", attributes: attributes, content: content())
}

public func mark(_ attributes: HTMLAttribute<Void>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<Void, some Node> {
  .init(name: "mark", attributes: attributes, content: content())
}

public func q(_ attributes: HTMLAttribute<QuoteElement>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<QuoteElement, some Node> {
  .init(name: "q", attributes: attributes, content: content())
}

public func rp(_ attributes: HTMLAttribute<Void>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<Void, some Node> {
  .init(name: "rp", attributes: attributes, content: content())
}

public func rt(_ attributes: HTMLAttribute<Void>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<Void, some Node> {
  .init(name: "rt", attributes: attributes, content: content())
}

public func ruby(_ attributes: HTMLAttribute<Void>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<Void, some Node> {
  .init(name: "ruby", attributes: attributes, content: content())
}

public func s(_ attributes: HTMLAttribute<Void>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<Void, some Node> {
  .init(name: "s", attributes: attributes, content: content())
}

public func samp(_ attributes: HTMLAttribute<Void>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<Void, some Node> {
  .init(name: "samp", attributes: attributes, content: content())
}

public func small(_ attributes: HTMLAttribute<Void>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<Void, some Node> {
  .init(name: "small", attributes: attributes, content: content())
}

public func span(_ attributes: HTMLAttribute<Void>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<Void, some Node> {
  .init(name: "span", attributes: attributes, content: content())
}

public func strong(_ attributes: HTMLAttribute<Void>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<Void, some Node> {
  .init(name: "strong", attributes: attributes, content: content())
}

public func sub(_ attributes: HTMLAttribute<Void>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<Void, some Node> {
  .init(name: "sub", attributes: attributes, content: content())
}

public func sup(_ attributes: HTMLAttribute<Void>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<Void, some Node> {
  .init(name: "sup", attributes: attributes, content: content())
}

public func time(_ attributes: HTMLAttribute<TimeElement>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<TimeElement, some Node> {
  .init(name: "time", attributes: attributes, content: content())
}

public func u(_ attributes: HTMLAttribute<Void>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<Void, some Node> {
  .init(name: "u", attributes: attributes, content: content())
}

public func `var`(_ attributes: HTMLAttribute<Void>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<Void, some Node> {
  .init(name: "var", attributes: attributes, content: content())
}

public func wbr(_ attributes: HTMLAttribute<Void>...) -> HTMLElement<Void, some Node> {
  .init(name: "wbr", attributes: attributes, content: _EmptyNode())
}

// MARK: - Image and Multimedia

public func area(_ attributes: HTMLAttribute<AreaElement>...) -> HTMLElement<AreaElement, some Node> {
  .init(name: "area", attributes: attributes, content: _EmptyNode())
}

public func audio(_ attributes: HTMLAttribute<MediaElement>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<MediaElement, some Node> {
  .init(name: "audio", attributes: attributes, content: content())
}

public func img(_ attributes: HTMLAttribute<ImageElement>...) -> HTMLElement<ImageElement, some Node> {
  .init(name: "img", attributes: attributes, content: _EmptyNode())
}

public func map(_ attributes: HTMLAttribute<Void>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<Void, some Node> {
  .init(name: "map", attributes: attributes, content: content())
}

public func track(_ attributes: HTMLAttribute<TrackElement>...) -> HTMLElement<TrackElement, some Node> {
  .init(name: "track", attributes: attributes, content: _EmptyNode())
}

public func video(_ attributes: HTMLAttribute<MediaElement>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<MediaElement, some Node> {
  .init(name: "video", attributes: attributes, content: content())
}

// MARK: - Embedded Content

public func embed(_ attributes: HTMLAttribute<EmbedElement>...) -> HTMLElement<EmbedElement, some Node> {
  .init(name: "embed", attributes: attributes, content: _EmptyNode())
}

public func iframe(_ attributes: HTMLAttribute<IframeElement>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<IframeElement, some Node> {
  .init(name: "iframe", attributes: attributes, content: content())
}

public func object(_ attributes: HTMLAttribute<ObjectElement>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<ObjectElement, some Node> {
  .init(name: "object", attributes: attributes, content: content())
}

public func picture(_ attributes: HTMLAttribute<Void>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<Void, some Node> {
  .init(name: "picture", attributes: attributes, content: content())
}

public func portal(_ attributes: HTMLAttribute<Void>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<Void, some Node> {
  .init(name: "portal", attributes: attributes, content: content())
}

public func source(_ attributes: HTMLAttribute<SourceElement>...) -> HTMLElement<SourceElement, some Node> {
  .init(name: "source", attributes: attributes, content: _EmptyNode())
}

// MARK: - SVG and MathML

public func svg(_ attributes: HTMLAttribute<Void>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<Void, some Node> {
  .init(name: "svg", attributes: attributes, content: content())
}

public func math(_ attributes: HTMLAttribute<Void>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<Void, some Node> {
  .init(name: "math", attributes: attributes, content: content())
}

// MARK: - Scripting

public func canvas(_ attributes: HTMLAttribute<CanvasElement>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<CanvasElement, some Node> {
  .init(name: "canvas", attributes: attributes, content: content())
}

public func noscript(_ attributes: HTMLAttribute<Void>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<Void, some Node> {
  .init(name: "noscript", attributes: attributes, content: content())
}

public func script(_ attributes: HTMLAttribute<ScriptElement>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<ScriptElement, some Node> {
  .init(name: "script", attributes: attributes, content: content())
}

// MARK: - Demarcating Edits

public func del(_ attributes: HTMLAttribute<ModElement>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<ModElement, some Node> {
  .init(name: "del", attributes: attributes, content: content())
}

public func ins(_ attributes: HTMLAttribute<ModElement>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<ModElement, some Node> {
  .init(name: "ins", attributes: attributes, content: content())
}

// MARK: - Table Content

public func caption(_ attributes: HTMLAttribute<Void>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<Void, some Node> {
  .init(name: "caption", attributes: attributes, content: content())
}

public func col(_ attributes: HTMLAttribute<ColElement>...) -> HTMLElement<ColElement, some Node> {
  .init(name: "col", attributes: attributes, content: _EmptyNode())
}

public func colgroup(_ attributes: HTMLAttribute<ColElement>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<ColElement, some Node> {
  .init(name: "colgroup", attributes: attributes, content: content())
}

public func table(_ attributes: HTMLAttribute<Void>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<Void, some Node> {
  .init(name: "table", attributes: attributes, content: content())
}

public func tbody(_ attributes: HTMLAttribute<Void>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<Void, some Node> {
  .init(name: "tbody", attributes: attributes, content: content())
}

public func td(_ attributes: HTMLAttribute<TableCellElement>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<TableCellElement, some Node> {
  .init(name: "td", attributes: attributes, content: content())
}

public func tfoot(_ attributes: HTMLAttribute<Void>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<Void, some Node> {
  .init(name: "tfoot", attributes: attributes, content: content())
}

public func th(_ attributes: HTMLAttribute<TableCellElement>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<TableCellElement, some Node> {
  .init(name: "th", attributes: attributes, content: content())
}

public func thead(_ attributes: HTMLAttribute<Void>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<Void, some Node> {
  .init(name: "thead", attributes: attributes, content: content())
}

public func tr(_ attributes: HTMLAttribute<Void>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<Void, some Node> {
  .init(name: "tr", attributes: attributes, content: content())
}

// MARK: - Forms

public func button(_ attributes: HTMLAttribute<ButtonElement>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<ButtonElement, some Node> {
  .init(name: "button", attributes: attributes, content: content())
}

public func datalist(_ attributes: HTMLAttribute<Void>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<Void, some Node> {
  .init(name: "datalist", attributes: attributes, content: content())
}

public func fieldset(_ attributes: HTMLAttribute<FieldsetElement>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<FieldsetElement, some Node> {
  .init(name: "fieldset", attributes: attributes, content: content())
}

public func form(_ attributes: HTMLAttribute<FormElement>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<FormElement, some Node> {
  .init(name: "form", attributes: attributes, content: content())
}

public func input(_ attributes: HTMLAttribute<InputElement>...) -> HTMLElement<InputElement, some Node> {
  .init(name: "input", attributes: attributes, content: _EmptyNode())
}

public func label(_ attributes: HTMLAttribute<LabelElement>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<LabelElement, some Node> {
  .init(name: "label", attributes: attributes, content: content())
}

public func legend(_ attributes: HTMLAttribute<Void>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<Void, some Node> {
  .init(name: "legend", attributes: attributes, content: content())
}

public func meter(_ attributes: HTMLAttribute<MeterElement>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<MeterElement, some Node> {
  .init(name: "meter", attributes: attributes, content: content())
}

public func optgroup(_ attributes: HTMLAttribute<OptgroupElement>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<OptgroupElement, some Node> {
  .init(name: "optgroup", attributes: attributes, content: content())
}

public func option(_ attributes: HTMLAttribute<OptionElement>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<OptionElement, some Node> {
  .init(name: "option", attributes: attributes, content: content())
}

public func output(_ attributes: HTMLAttribute<OutputElement>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<OutputElement, some Node> {
  .init(name: "output", attributes: attributes, content: content())
}

public func progress(_ attributes: HTMLAttribute<MeterElement>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<MeterElement, some Node> {
  .init(name: "progress", attributes: attributes, content: content())
}

public func select(_ attributes: HTMLAttribute<SelectElement>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<SelectElement, some Node> {
  .init(name: "select", attributes: attributes, content: content())
}

public func textarea(_ attributes: HTMLAttribute<TextareaElement>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<TextareaElement, some Node> {
  .init(name: "textarea", attributes: attributes, content: content())
}

// MARK: - Interactive Elements

public func details(_ attributes: HTMLAttribute<DetailsElement>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<DetailsElement, some Node> {
  .init(name: "details", attributes: attributes, content: content())
}

public func dialog(_ attributes: HTMLAttribute<DialogElement>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<DialogElement, some Node> {
  .init(name: "dialog", attributes: attributes, content: content())
}

public func summary(_ attributes: HTMLAttribute<Void>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<Void, some Node> {
  .init(name: "summary", attributes: attributes, content: content())
}

// MARK: - Web Components

public func slot(_ attributes: HTMLAttribute<Void>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<Void, some Node> {
  .init(name: "slot", attributes: attributes, content: content())
}

public func template(_ attributes: HTMLAttribute<Void>..., @HTMLBuilder content: () -> some Node) -> HTMLElement<Void, some Node> {
  .init(name: "template", attributes: attributes, content: content())
}
