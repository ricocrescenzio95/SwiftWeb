public protocol HTMLElement: Node {
  associatedtype AttributesType
  static var name: String { get }
  var attributes: [HTMLAttribute<AttributesType>] { get }
}

// MARK: - API

public struct rawHTML: Node {
  public var content: some Node { EmptyNode() }
  public let raw: String
  
  public init(_ raw: String) {
    self.raw = raw
  }
}

// MARK: - Document Metadata

public enum HeadHTMLAttribute {}
public struct HeadHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = HeadHTMLAttribute
  public static var name: String { "head"}
  public var attributes: [HTMLAttribute<HeadHTMLAttribute>]
  public var content: Content
}
public func head(_ attributes: HTMLAttribute<HeadHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> HeadHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func head(_ attributes: [HTMLAttribute<HeadHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> HeadHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum TitleHTMLAttribute {}
public struct TitleHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = TitleHTMLAttribute
  public static var name: String { "title" }
  public var attributes: [HTMLAttribute<TitleHTMLAttribute>]
  public var content: Content
}
public func title(_ attributes: HTMLAttribute<TitleHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> TitleHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func title(_ attributes: [HTMLAttribute<TitleHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> TitleHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum BaseHTMLAttribute {}
public struct BaseHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = BaseHTMLAttribute
  public static var name: String { "base" }
  public var attributes: [HTMLAttribute<BaseHTMLAttribute>]
  public var content: Content
}
public func base(_ attributes: HTMLAttribute<BaseHTMLAttribute>...) -> BaseHTMLElement<some Node> {
  .init(attributes: attributes, content: EmptyNode())
}
public func base(_ attributes: [HTMLAttribute<BaseHTMLAttribute>]) -> BaseHTMLElement<some Node> {
  .init(attributes: attributes, content: EmptyNode())
}

public enum LinkHTMLAttribute {}
public struct LinkHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = LinkHTMLAttribute
  public static var name: String { "link" }
  public var attributes: [HTMLAttribute<LinkHTMLAttribute>]
  public var content: Content
}
public func link(_ attributes: HTMLAttribute<LinkHTMLAttribute>...) -> LinkHTMLElement<some Node> {
  .init(attributes: attributes, content: EmptyNode())
}
public func link(_ attributes: [HTMLAttribute<LinkHTMLAttribute>]) -> LinkHTMLElement<some Node> {
  .init(attributes: attributes, content: EmptyNode())
}

public enum MetaHTMLAttribute {}
public struct MetaHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = MetaHTMLAttribute
  public static var name: String { "meta" }
  public var attributes: [HTMLAttribute<MetaHTMLAttribute>]
  public var content: Content
}
public func meta(_ attributes: HTMLAttribute<MetaHTMLAttribute>...) -> MetaHTMLElement<some Node> {
  .init(attributes: attributes, content: EmptyNode())
}
public func meta(_ attributes: [HTMLAttribute<MetaHTMLAttribute>]) -> MetaHTMLElement<some Node> {
  .init(attributes: attributes, content: EmptyNode())
}

public enum StyleHTMLAttribute {}
public struct StyleHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = StyleHTMLAttribute
  public static var name: String { "style" }
  public var attributes: [HTMLAttribute<StyleHTMLAttribute>]
  public var content: Content
}
public func style(_ attributes: HTMLAttribute<StyleHTMLAttribute>..., @CSS content: () -> [CSS.Selector]) -> StyleHTMLElement<some Node> {
  .init(attributes: attributes, content: content().lazy.map(\.cssValue).joined(separator: "\n"))
}
public func style(_ attributes: [HTMLAttribute<StyleHTMLAttribute>], @CSS content: () -> [CSS.Selector]) -> StyleHTMLElement<some Node> {
  .init(attributes: attributes, content: content().lazy.map(\.cssValue).joined(separator: "\n"))
}

// MARK: - Sectioning Root

public enum BodyHTMLAttribute {}
public struct BodyHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = BodyHTMLAttribute
  public static var name: String { "body" }
  public var attributes: [HTMLAttribute<BodyHTMLAttribute>]
  public var content: Content
}
public func body(_ attributes: HTMLAttribute<BodyHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> BodyHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func body(_ attributes: [HTMLAttribute<BodyHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> BodyHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

// MARK: - Content Sectioning

public enum AddressHTMLAttribute {}
public struct AddressHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = AddressHTMLAttribute
  public static var name: String { "address" }
  public var attributes: [HTMLAttribute<AddressHTMLAttribute>]
  public var content: Content
}
public func address(_ attributes: HTMLAttribute<AddressHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> AddressHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func address(_ attributes: [HTMLAttribute<AddressHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> AddressHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum ArticleHTMLAttribute {}
public struct ArticleHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = ArticleHTMLAttribute
  public static var name: String { "article" }
  public var attributes: [HTMLAttribute<ArticleHTMLAttribute>]
  public var content: Content
}
public func article(_ attributes: HTMLAttribute<ArticleHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> ArticleHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func article(_ attributes: [HTMLAttribute<ArticleHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> ArticleHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum AsideHTMLAttribute {}
public struct AsideHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = AsideHTMLAttribute
  public static var name: String { "aside" }
  public var attributes: [HTMLAttribute<AsideHTMLAttribute>]
  public var content: Content
}
public func aside(_ attributes: HTMLAttribute<AsideHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> AsideHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func aside(_ attributes: [HTMLAttribute<AsideHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> AsideHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum FooterHTMLAttribute {}
public struct FooterHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = FooterHTMLAttribute
  public static var name: String { "footer" }
  public var attributes: [HTMLAttribute<FooterHTMLAttribute>]
  public var content: Content
}
public func footer(_ attributes: HTMLAttribute<FooterHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> FooterHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func footer(_ attributes: [HTMLAttribute<FooterHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> FooterHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum HeaderHTMLAttribute {}
public struct HeaderHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = HeaderHTMLAttribute
  public static var name: String { "header" }
  public var attributes: [HTMLAttribute<HeaderHTMLAttribute>]
  public var content: Content
}
public func header(_ attributes: HTMLAttribute<HeaderHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> HeaderHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func header(_ attributes: [HTMLAttribute<HeaderHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> HeaderHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum H1HTMLAttribute {}
public struct H1HTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = H1HTMLAttribute
  public static var name: String { "h1" }
  public var attributes: [HTMLAttribute<H1HTMLAttribute>]
  public var content: Content
}
public func h1(_ attributes: HTMLAttribute<H1HTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> H1HTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func h1(_ attributes: [HTMLAttribute<H1HTMLAttribute>], @HTMLBuilder content: () -> some Node) -> H1HTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum H2HTMLAttribute {}
public struct H2HTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = H2HTMLAttribute
  public static var name: String { "h2" }
  public var attributes: [HTMLAttribute<H2HTMLAttribute>]
  public var content: Content
}
public func h2(_ attributes: HTMLAttribute<H2HTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> H2HTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func h2(_ attributes: [HTMLAttribute<H2HTMLAttribute>], @HTMLBuilder content: () -> some Node) -> H2HTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum H3HTMLAttribute {}
public struct H3HTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = H3HTMLAttribute
  public static var name: String { "h3" }
  public var attributes: [HTMLAttribute<H3HTMLAttribute>]
  public var content: Content
}
public func h3(_ attributes: HTMLAttribute<H3HTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> H3HTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func h3(_ attributes: [HTMLAttribute<H3HTMLAttribute>], @HTMLBuilder content: () -> some Node) -> H3HTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum H4HTMLAttribute {}
public struct H4HTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = H4HTMLAttribute
  public static var name: String { "h4" }
  public var attributes: [HTMLAttribute<H4HTMLAttribute>]
  public var content: Content
}
public func h4(_ attributes: HTMLAttribute<H4HTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> H4HTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func h4(_ attributes: [HTMLAttribute<H4HTMLAttribute>], @HTMLBuilder content: () -> some Node) -> H4HTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum H5HTMLAttribute {}
public struct H5HTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = H5HTMLAttribute
  public static var name: String { "h5" }
  public var attributes: [HTMLAttribute<H5HTMLAttribute>]
  public var content: Content
}
public func h5(_ attributes: HTMLAttribute<H5HTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> H5HTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func h5(_ attributes: [HTMLAttribute<H5HTMLAttribute>], @HTMLBuilder content: () -> some Node) -> H5HTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum H6HTMLAttribute {}
public struct H6HTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = H6HTMLAttribute
  public static var name: String { "h6" }
  public var attributes: [HTMLAttribute<H6HTMLAttribute>]
  public var content: Content
}
public func h6(_ attributes: HTMLAttribute<H6HTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> H6HTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func h6(_ attributes: [HTMLAttribute<H6HTMLAttribute>], @HTMLBuilder content: () -> some Node) -> H6HTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum HgroupHTMLAttribute {}
public struct HgroupHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = HgroupHTMLAttribute
  public static var name: String { "hgroup" }
  public var attributes: [HTMLAttribute<HgroupHTMLAttribute>]
  public var content: Content
}
public func hgroup(_ attributes: HTMLAttribute<HgroupHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> HgroupHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func hgroup(_ attributes: [HTMLAttribute<HgroupHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> HgroupHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum MainHTMLAttribute {}
public struct MainHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = MainHTMLAttribute
  public static var name: String { "main" }
  public var attributes: [HTMLAttribute<MainHTMLAttribute>]
  public var content: Content
}
public func main(_ attributes: HTMLAttribute<MainHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> MainHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func main(_ attributes: [HTMLAttribute<MainHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> MainHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum NavHTMLAttribute {}
public struct NavHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = NavHTMLAttribute
  public static var name: String { "nav" }
  public var attributes: [HTMLAttribute<NavHTMLAttribute>]
  public var content: Content
}
public func nav(_ attributes: HTMLAttribute<NavHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> NavHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func nav(_ attributes: [HTMLAttribute<NavHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> NavHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum SectionHTMLAttribute {}
public struct SectionHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = SectionHTMLAttribute
  public static var name: String { "section" }
  public var attributes: [HTMLAttribute<SectionHTMLAttribute>]
  public var content: Content
}
public func section(_ attributes: HTMLAttribute<SectionHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> SectionHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func section(_ attributes: [HTMLAttribute<SectionHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> SectionHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum SearchHTMLAttribute {}
public struct SearchHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = SearchHTMLAttribute
  public static var name: String { "search" }
  public var attributes: [HTMLAttribute<SearchHTMLAttribute>]
  public var content: Content
}
public func search(_ attributes: HTMLAttribute<SearchHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> SearchHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func search(_ attributes: [HTMLAttribute<SearchHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> SearchHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

// MARK: - Text Content

public enum BlockquoteHTMLAttribute {}
public struct BlockquoteHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = BlockquoteHTMLAttribute
  public static var name: String { "blockquote" }
  public var attributes: [HTMLAttribute<BlockquoteHTMLAttribute>]
  public var content: Content
}
public func blockquote(_ attributes: HTMLAttribute<BlockquoteHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> BlockquoteHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func blockquote(_ attributes: [HTMLAttribute<BlockquoteHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> BlockquoteHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum DdHTMLAttribute {}
public struct DdHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = DdHTMLAttribute
  public static var name: String { "dd" }
  public var attributes: [HTMLAttribute<DdHTMLAttribute>]
  public var content: Content
}
public func dd(_ attributes: HTMLAttribute<DdHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> DdHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func dd(_ attributes: [HTMLAttribute<DdHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> DdHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum DivHTMLAttribute {}
public struct DivHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = DivHTMLAttribute
  public static var name: String { "div" }
  public var attributes: [HTMLAttribute<DivHTMLAttribute>]
  public var content: Content
}
public func div(_ attributes: HTMLAttribute<DivHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> DivHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func div(_ attributes: [HTMLAttribute<DivHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> DivHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum DlHTMLAttribute {}
public struct DlHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = DlHTMLAttribute
  public static var name: String { "dl" }
  public var attributes: [HTMLAttribute<DlHTMLAttribute>]
  public var content: Content
}
public func dl(_ attributes: HTMLAttribute<DlHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> DlHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func dl(_ attributes: [HTMLAttribute<DlHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> DlHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum DtHTMLAttribute {}
public struct DtHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = DtHTMLAttribute
  public static var name: String { "dt" }
  public var attributes: [HTMLAttribute<DtHTMLAttribute>]
  public var content: Content
}
public func dt(_ attributes: HTMLAttribute<DtHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> DtHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func dt(_ attributes: [HTMLAttribute<DtHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> DtHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum FigcaptionHTMLAttribute {}
public struct FigcaptionHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = FigcaptionHTMLAttribute
  public static var name: String { "figcaption" }
  public var attributes: [HTMLAttribute<FigcaptionHTMLAttribute>]
  public var content: Content
}
public func figcaption(_ attributes: HTMLAttribute<FigcaptionHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> FigcaptionHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func figcaption(_ attributes: [HTMLAttribute<FigcaptionHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> FigcaptionHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum FigureHTMLAttribute {}
public struct FigureHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = FigureHTMLAttribute
  public static var name: String { "figure" }
  public var attributes: [HTMLAttribute<FigureHTMLAttribute>]
  public var content: Content
}
public func figure(_ attributes: HTMLAttribute<FigureHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> FigureHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func figure(_ attributes: [HTMLAttribute<FigureHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> FigureHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum HrHTMLAttribute {}
public struct HrHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = HrHTMLAttribute
  public static var name: String { "hr" }
  public var attributes: [HTMLAttribute<HrHTMLAttribute>]
  public var content: Content
}
public func hr(_ attributes: HTMLAttribute<HrHTMLAttribute>...) -> HrHTMLElement<some Node> {
  .init(attributes: attributes, content: EmptyNode())
}
public func hr(_ attributes: [HTMLAttribute<HrHTMLAttribute>]) -> HrHTMLElement<some Node> {
  .init(attributes: attributes, content: EmptyNode())
}

public enum LiHTMLAttribute {}
public struct LiHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = LiHTMLAttribute
  public static var name: String { "li" }
  public var attributes: [HTMLAttribute<LiHTMLAttribute>]
  public var content: Content
}
public func li(_ attributes: HTMLAttribute<LiHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> LiHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func li(_ attributes: [HTMLAttribute<LiHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> LiHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum MenuHTMLAttribute {}
public struct MenuHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = MenuHTMLAttribute
  public static var name: String { "menu" }
  public var attributes: [HTMLAttribute<MenuHTMLAttribute>]
  public var content: Content
}
public func menu(_ attributes: HTMLAttribute<MenuHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> MenuHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func menu(_ attributes: [HTMLAttribute<MenuHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> MenuHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum OlHTMLAttribute {}
public struct OlHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = OlHTMLAttribute
  public static var name: String { "ol" }
  public var attributes: [HTMLAttribute<OlHTMLAttribute>]
  public var content: Content
}
public func ol(_ attributes: HTMLAttribute<OlHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> OlHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func ol(_ attributes: [HTMLAttribute<OlHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> OlHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum PHTMLAttribute {}
public struct PHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = PHTMLAttribute
  public static var name: String { "p" }
  public var attributes: [HTMLAttribute<PHTMLAttribute>]
  public var content: Content
}
public func p(_ attributes: HTMLAttribute<PHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> PHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func p(_ attributes: [HTMLAttribute<PHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> PHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum PreHTMLAttribute {}
public struct PreHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = PreHTMLAttribute
  public static var name: String { "pre" }
  public var attributes: [HTMLAttribute<PreHTMLAttribute>]
  public var content: Content
}
public func pre(_ attributes: HTMLAttribute<PreHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> PreHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func pre(_ attributes: [HTMLAttribute<PreHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> PreHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum UlHTMLAttribute {}
public struct UlHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = UlHTMLAttribute
  public static var name: String { "ul" }
  public var attributes: [HTMLAttribute<UlHTMLAttribute>]
  public var content: Content
}
public func ul(_ attributes: HTMLAttribute<UlHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> UlHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func ul(_ attributes: [HTMLAttribute<UlHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> UlHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

// MARK: - Inline Text Semantics

public enum AHTMLAttribute {}
public struct AHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = AHTMLAttribute
  public static var name: String { "a" }
  public var attributes: [HTMLAttribute<AHTMLAttribute>]
  public var content: Content
}
public func a(_ attributes: HTMLAttribute<AHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> AHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func a(_ attributes: [HTMLAttribute<AHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> AHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum AbbrHTMLAttribute {}
public struct AbbrHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = AbbrHTMLAttribute
  public static var name: String { "abbr" }
  public var attributes: [HTMLAttribute<AbbrHTMLAttribute>]
  public var content: Content
}
public func abbr(_ attributes: HTMLAttribute<AbbrHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> AbbrHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func abbr(_ attributes: [HTMLAttribute<AbbrHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> AbbrHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum BHTMLAttribute {}
public struct BHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = BHTMLAttribute
  public static var name: String { "b" }
  public var attributes: [HTMLAttribute<BHTMLAttribute>]
  public var content: Content
}
public func b(_ attributes: HTMLAttribute<BHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> BHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func b(_ attributes: [HTMLAttribute<BHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> BHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum BdiHTMLAttribute {}
public struct BdiHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = BdiHTMLAttribute
  public static var name: String { "bdi" }
  public var attributes: [HTMLAttribute<BdiHTMLAttribute>]
  public var content: Content
}
public func bdi(_ attributes: HTMLAttribute<BdiHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> BdiHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func bdi(_ attributes: [HTMLAttribute<BdiHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> BdiHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum BdoHTMLAttribute {}
public struct BdoHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = BdoHTMLAttribute
  public static var name: String { "bdo" }
  public var attributes: [HTMLAttribute<BdoHTMLAttribute>]
  public var content: Content
}
public func bdo(_ attributes: HTMLAttribute<BdoHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> BdoHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func bdo(_ attributes: [HTMLAttribute<BdoHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> BdoHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum BrHTMLAttribute {}
public struct BrHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = BrHTMLAttribute
  public static var name: String { "br" }
  public var attributes: [HTMLAttribute<BrHTMLAttribute>]
  public var content: Content
}
public func br(_ attributes: HTMLAttribute<BrHTMLAttribute>...) -> BrHTMLElement<some Node> {
  .init(attributes: attributes, content: EmptyNode())
}
public func br(_ attributes: [HTMLAttribute<BrHTMLAttribute>]) -> BrHTMLElement<some Node> {
  .init(attributes: attributes, content: EmptyNode())
}

public enum CiteHTMLAttribute {}
public struct CiteHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = CiteHTMLAttribute
  public static var name: String { "cite" }
  public var attributes: [HTMLAttribute<CiteHTMLAttribute>]
  public var content: Content
}
public func cite(_ attributes: HTMLAttribute<CiteHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> CiteHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func cite(_ attributes: [HTMLAttribute<CiteHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> CiteHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum CodeHTMLAttribute {}
public struct CodeHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = CodeHTMLAttribute
  public static var name: String { "code" }
  public var attributes: [HTMLAttribute<CodeHTMLAttribute>]
  public var content: Content
}
public func code(_ attributes: HTMLAttribute<CodeHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> CodeHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func code(_ attributes: [HTMLAttribute<CodeHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> CodeHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum DataHTMLAttribute {}
public struct DataHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = DataHTMLAttribute
  public static var name: String { "data" }
  public var attributes: [HTMLAttribute<DataHTMLAttribute>]
  public var content: Content
}
public func data(_ attributes: HTMLAttribute<DataHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> DataHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func data(_ attributes: [HTMLAttribute<DataHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> DataHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum DfnHTMLAttribute {}
public struct DfnHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = DfnHTMLAttribute
  public static var name: String { "dfn" }
  public var attributes: [HTMLAttribute<DfnHTMLAttribute>]
  public var content: Content
}
public func dfn(_ attributes: HTMLAttribute<DfnHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> DfnHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func dfn(_ attributes: [HTMLAttribute<DfnHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> DfnHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum EmHTMLAttribute {}
public struct EmHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = EmHTMLAttribute
  public static var name: String { "em" }
  public var attributes: [HTMLAttribute<EmHTMLAttribute>]
  public var content: Content
}
public func em(_ attributes: HTMLAttribute<EmHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> EmHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func em(_ attributes: [HTMLAttribute<EmHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> EmHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum IHTMLAttribute {}
public struct IHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = IHTMLAttribute
  public static var name: String { "i" }
  public var attributes: [HTMLAttribute<IHTMLAttribute>]
  public var content: Content
}
public func i(_ attributes: HTMLAttribute<IHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> IHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func i(_ attributes: [HTMLAttribute<IHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> IHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum KbdHTMLAttribute {}
public struct KbdHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = KbdHTMLAttribute
  public static var name: String { "kbd" }
  public var attributes: [HTMLAttribute<KbdHTMLAttribute>]
  public var content: Content
}
public func kbd(_ attributes: HTMLAttribute<KbdHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> KbdHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func kbd(_ attributes: [HTMLAttribute<KbdHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> KbdHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum MarkHTMLAttribute {}
public struct MarkHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = MarkHTMLAttribute
  public static var name: String { "mark" }
  public var attributes: [HTMLAttribute<MarkHTMLAttribute>]
  public var content: Content
}
public func mark(_ attributes: HTMLAttribute<MarkHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> MarkHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func mark(_ attributes: [HTMLAttribute<MarkHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> MarkHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum QHTMLAttribute {}
public struct QHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = QHTMLAttribute
  public static var name: String { "q" }
  public var attributes: [HTMLAttribute<QHTMLAttribute>]
  public var content: Content
}
public func q(_ attributes: HTMLAttribute<QHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> QHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func q(_ attributes: [HTMLAttribute<QHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> QHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum RpHTMLAttribute {}
public struct RpHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = RpHTMLAttribute
  public static var name: String { "rp" }
  public var attributes: [HTMLAttribute<RpHTMLAttribute>]
  public var content: Content
}
public func rp(_ attributes: HTMLAttribute<RpHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> RpHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func rp(_ attributes: [HTMLAttribute<RpHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> RpHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum RtHTMLAttribute {}
public struct RtHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = RtHTMLAttribute
  public static var name: String { "rt" }
  public var attributes: [HTMLAttribute<RtHTMLAttribute>]
  public var content: Content
}
public func rt(_ attributes: HTMLAttribute<RtHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> RtHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func rt(_ attributes: [HTMLAttribute<RtHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> RtHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum RubyHTMLAttribute {}
public struct RubyHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = RubyHTMLAttribute
  public static var name: String { "ruby" }
  public var attributes: [HTMLAttribute<RubyHTMLAttribute>]
  public var content: Content
}
public func ruby(_ attributes: HTMLAttribute<RubyHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> RubyHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func ruby(_ attributes: [HTMLAttribute<RubyHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> RubyHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum SHTMLAttribute {}
public struct SHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = SHTMLAttribute
  public static var name: String { "s" }
  public var attributes: [HTMLAttribute<SHTMLAttribute>]
  public var content: Content
}
public func s(_ attributes: HTMLAttribute<SHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> SHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func s(_ attributes: [HTMLAttribute<SHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> SHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum SampHTMLAttribute {}
public struct SampHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = SampHTMLAttribute
  public static var name: String { "samp" }
  public var attributes: [HTMLAttribute<SampHTMLAttribute>]
  public var content: Content
}
public func samp(_ attributes: HTMLAttribute<SampHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> SampHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func samp(_ attributes: [HTMLAttribute<SampHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> SampHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum SmallHTMLAttribute {}
public struct SmallHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = SmallHTMLAttribute
  public static var name: String { "small" }
  public var attributes: [HTMLAttribute<SmallHTMLAttribute>]
  public var content: Content
}
public func small(_ attributes: HTMLAttribute<SmallHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> SmallHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func small(_ attributes: [HTMLAttribute<SmallHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> SmallHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum SpanHTMLAttribute {}
public struct SpanHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = SpanHTMLAttribute
  public static var name: String { "span" }
  public var attributes: [HTMLAttribute<SpanHTMLAttribute>]
  public var content: Content
}
public func span(_ attributes: HTMLAttribute<SpanHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> SpanHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func span(_ attributes: [HTMLAttribute<SpanHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> SpanHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum StrongHTMLAttribute {}
public struct StrongHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = StrongHTMLAttribute
  public static var name: String { "strong" }
  public var attributes: [HTMLAttribute<StrongHTMLAttribute>]
  public var content: Content
}
public func strong(_ attributes: HTMLAttribute<StrongHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> StrongHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func strong(_ attributes: [HTMLAttribute<StrongHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> StrongHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum SubHTMLAttribute {}
public struct SubHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = SubHTMLAttribute
  public static var name: String { "sub" }
  public var attributes: [HTMLAttribute<SubHTMLAttribute>]
  public var content: Content
}
public func sub(_ attributes: HTMLAttribute<SubHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> SubHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func sub(_ attributes: [HTMLAttribute<SubHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> SubHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum SupHTMLAttribute {}
public struct SupHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = SupHTMLAttribute
  public static var name: String { "sup" }
  public var attributes: [HTMLAttribute<SupHTMLAttribute>]
  public var content: Content
}
public func sup(_ attributes: HTMLAttribute<SupHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> SupHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func sup(_ attributes: [HTMLAttribute<SupHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> SupHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum TimeHTMLAttribute {}
public struct TimeHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = TimeHTMLAttribute
  public static var name: String { "time" }
  public var attributes: [HTMLAttribute<TimeHTMLAttribute>]
  public var content: Content
}
public func time(_ attributes: HTMLAttribute<TimeHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> TimeHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func time(_ attributes: [HTMLAttribute<TimeHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> TimeHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum UHTMLAttribute {}
public struct UHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = UHTMLAttribute
  public static var name: String { "u" }
  public var attributes: [HTMLAttribute<UHTMLAttribute>]
  public var content: Content
}
public func u(_ attributes: HTMLAttribute<UHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> UHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func u(_ attributes: [HTMLAttribute<UHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> UHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum VarHTMLAttribute {}
public struct VarHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = VarHTMLAttribute
  public static var name: String { "var" }
  public var attributes: [HTMLAttribute<VarHTMLAttribute>]
  public var content: Content
}
public func `var`(_ attributes: HTMLAttribute<VarHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> VarHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func `var`(_ attributes: [HTMLAttribute<VarHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> VarHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum WbrHTMLAttribute {}
public struct WbrHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = WbrHTMLAttribute
  public static var name: String { "wbr" }
  public var attributes: [HTMLAttribute<WbrHTMLAttribute>]
  public var content: Content
}
public func wbr(_ attributes: HTMLAttribute<WbrHTMLAttribute>...) -> WbrHTMLElement<some Node> {
  .init(attributes: attributes, content: EmptyNode())
}
public func wbr(_ attributes: [HTMLAttribute<WbrHTMLAttribute>]) -> WbrHTMLElement<some Node> {
  .init(attributes: attributes, content: EmptyNode())
}

// MARK: - Image and Multimedia

public enum AreaHTMLAttribute {}
public struct AreaHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = AreaHTMLAttribute
  public static var name: String { "area" }
  public var attributes: [HTMLAttribute<AreaHTMLAttribute>]
  public var content: Content
}
public func area(_ attributes: HTMLAttribute<AreaHTMLAttribute>...) -> AreaHTMLElement<some Node> {
  .init(attributes: attributes, content: EmptyNode())
}
public func area(_ attributes: [HTMLAttribute<AreaHTMLAttribute>]) -> AreaHTMLElement<some Node> {
  .init(attributes: attributes, content: EmptyNode())
}

public enum AudioHTMLAttribute {}
public struct AudioHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = AudioHTMLAttribute
  public static var name: String { "audio" }
  public var attributes: [HTMLAttribute<AudioHTMLAttribute>]
  public var content: Content
}
public func audio(_ attributes: HTMLAttribute<AudioHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> AudioHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func audio(_ attributes: [HTMLAttribute<AudioHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> AudioHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum ImgHTMLAttribute {}
public struct ImgHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = ImgHTMLAttribute
  public static var name: String { "img" }
  public var attributes: [HTMLAttribute<ImgHTMLAttribute>]
  public var content: Content
}
public func img(_ attributes: HTMLAttribute<ImgHTMLAttribute>...) -> ImgHTMLElement<some Node> {
  .init(attributes: attributes, content: EmptyNode())
}
public func img(_ attributes: [HTMLAttribute<ImgHTMLAttribute>]) -> ImgHTMLElement<some Node> {
  .init(attributes: attributes, content: EmptyNode())
}

public enum MapHTMLAttribute {}
public struct MapHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = MapHTMLAttribute
  public static var name: String { "map" }
  public var attributes: [HTMLAttribute<MapHTMLAttribute>]
  public var content: Content
}
public func map(_ attributes: HTMLAttribute<MapHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> MapHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func map(_ attributes: [HTMLAttribute<MapHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> MapHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum TrackHTMLAttribute {}
public struct TrackHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = TrackHTMLAttribute
  public static var name: String { "track" }
  public var attributes: [HTMLAttribute<TrackHTMLAttribute>]
  public var content: Content
}
public func track(_ attributes: HTMLAttribute<TrackHTMLAttribute>...) -> TrackHTMLElement<some Node> {
  .init(attributes: attributes, content: EmptyNode())
}
public func track(_ attributes: [HTMLAttribute<TrackHTMLAttribute>]) -> TrackHTMLElement<some Node> {
  .init(attributes: attributes, content: EmptyNode())
}

public enum VideoHTMLAttribute {}
public struct VideoHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = VideoHTMLAttribute
  public static var name: String { "video" }
  public var attributes: [HTMLAttribute<VideoHTMLAttribute>]
  public var content: Content
}
public func video(_ attributes: HTMLAttribute<VideoHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> VideoHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func video(_ attributes: [HTMLAttribute<VideoHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> VideoHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

// MARK: - Embedded Content

public enum EmbedHTMLAttribute {}
public struct EmbedHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = EmbedHTMLAttribute
  public static var name: String { "embed" }
  public var attributes: [HTMLAttribute<EmbedHTMLAttribute>]
  public var content: Content
}
public func embed(_ attributes: HTMLAttribute<EmbedHTMLAttribute>...) -> EmbedHTMLElement<some Node> {
  .init(attributes: attributes, content: EmptyNode())
}
public func embed(_ attributes: [HTMLAttribute<EmbedHTMLAttribute>]) -> EmbedHTMLElement<some Node> {
  .init(attributes: attributes, content: EmptyNode())
}

public enum IframeHTMLAttribute {}
public struct IframeHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = IframeHTMLAttribute
  public static var name: String { "iframe" }
  public var attributes: [HTMLAttribute<IframeHTMLAttribute>]
  public var content: Content
}
public func iframe(_ attributes: HTMLAttribute<IframeHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> IframeHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func iframe(_ attributes: [HTMLAttribute<IframeHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> IframeHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum ObjectHTMLAttribute {}
public struct ObjectHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = ObjectHTMLAttribute
  public static var name: String { "object" }
  public var attributes: [HTMLAttribute<ObjectHTMLAttribute>]
  public var content: Content
}
public func object(_ attributes: HTMLAttribute<ObjectHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> ObjectHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func object(_ attributes: [HTMLAttribute<ObjectHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> ObjectHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum PictureHTMLAttribute {}
public struct PictureHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = PictureHTMLAttribute
  public static var name: String { "picture" }
  public var attributes: [HTMLAttribute<PictureHTMLAttribute>]
  public var content: Content
}
public func picture(_ attributes: HTMLAttribute<PictureHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> PictureHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func picture(_ attributes: [HTMLAttribute<PictureHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> PictureHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum PortalHTMLAttribute {}
public struct PortalHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = PortalHTMLAttribute
  public static var name: String { "portal" }
  public var attributes: [HTMLAttribute<PortalHTMLAttribute>]
  public var content: Content
}
public func portal(_ attributes: HTMLAttribute<PortalHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> PortalHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func portal(_ attributes: [HTMLAttribute<PortalHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> PortalHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum SourceHTMLAttribute {}
public struct SourceHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = SourceHTMLAttribute
  public static var name: String { "source" }
  public var attributes: [HTMLAttribute<SourceHTMLAttribute>]
  public var content: Content
}
public func source(_ attributes: HTMLAttribute<SourceHTMLAttribute>...) -> SourceHTMLElement<some Node> {
  .init(attributes: attributes, content: EmptyNode())
}
public func source(_ attributes: [HTMLAttribute<SourceHTMLAttribute>]) -> SourceHTMLElement<some Node> {
  .init(attributes: attributes, content: EmptyNode())
}

// MARK: - SVG and MathML

public enum SvgHTMLAttribute {}
public struct SvgHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = SvgHTMLAttribute
  public static var name: String { "svg" }
  public var attributes: [HTMLAttribute<SvgHTMLAttribute>]
  public var content: Content
}
public func svg(_ attributes: HTMLAttribute<SvgHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> SvgHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func svg(_ attributes: [HTMLAttribute<SvgHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> SvgHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum MathHTMLAttribute {}
public struct MathHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = MathHTMLAttribute
  public static var name: String { "math" }
  public var attributes: [HTMLAttribute<MathHTMLAttribute>]
  public var content: Content
}
public func math(_ attributes: HTMLAttribute<MathHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> MathHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func math(_ attributes: [HTMLAttribute<MathHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> MathHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

// MARK: - Scripting

public enum CanvasHTMLAttribute {}
public struct CanvasHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = CanvasHTMLAttribute
  public static var name: String { "canvas" }
  public var attributes: [HTMLAttribute<CanvasHTMLAttribute>]
  public var content: Content
}
public func canvas(_ attributes: HTMLAttribute<CanvasHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> CanvasHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func canvas(_ attributes: [HTMLAttribute<CanvasHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> CanvasHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum NoscriptHTMLAttribute {}
public struct NoscriptHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = NoscriptHTMLAttribute
  public static var name: String { "noscript" }
  public var attributes: [HTMLAttribute<NoscriptHTMLAttribute>]
  public var content: Content
}
public func noscript(_ attributes: HTMLAttribute<NoscriptHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> NoscriptHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func noscript(_ attributes: [HTMLAttribute<NoscriptHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> NoscriptHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum ScriptHTMLAttribute {}
public struct ScriptHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = ScriptHTMLAttribute
  public static var name: String { "script" }
  public var attributes: [HTMLAttribute<ScriptHTMLAttribute>]
  public var content: Content
}
public func script(_ attributes: HTMLAttribute<ScriptHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> ScriptHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func script(_ attributes: [HTMLAttribute<ScriptHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> ScriptHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

// MARK: - Demarcating Edits

public enum DelHTMLAttribute {}
public struct DelHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = DelHTMLAttribute
  public static var name: String { "del" }
  public var attributes: [HTMLAttribute<DelHTMLAttribute>]
  public var content: Content
}
public func del(_ attributes: HTMLAttribute<DelHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> DelHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func del(_ attributes: [HTMLAttribute<DelHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> DelHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum InsHTMLAttribute {}
public struct InsHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = InsHTMLAttribute
  public static var name: String { "ins" }
  public var attributes: [HTMLAttribute<InsHTMLAttribute>]
  public var content: Content
}
public func ins(_ attributes: HTMLAttribute<InsHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> InsHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func ins(_ attributes: [HTMLAttribute<InsHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> InsHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

// MARK: - Table Content

public enum CaptionHTMLAttribute {}
public struct CaptionHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = CaptionHTMLAttribute
  public static var name: String { "caption" }
  public var attributes: [HTMLAttribute<CaptionHTMLAttribute>]
  public var content: Content
}
public func caption(_ attributes: HTMLAttribute<CaptionHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> CaptionHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func caption(_ attributes: [HTMLAttribute<CaptionHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> CaptionHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum ColHTMLAttribute {}
public struct ColHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = ColHTMLAttribute
  public static var name: String { "col" }
  public var attributes: [HTMLAttribute<ColHTMLAttribute>]
  public var content: Content
}
public func col(_ attributes: HTMLAttribute<ColHTMLAttribute>...) -> ColHTMLElement<some Node> {
  .init(attributes: attributes, content: EmptyNode())
}
public func col(_ attributes: [HTMLAttribute<ColHTMLAttribute>]) -> ColHTMLElement<some Node> {
  .init(attributes: attributes, content: EmptyNode())
}

public enum ColgroupHTMLAttribute {}
public struct ColgroupHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = ColgroupHTMLAttribute
  public static var name: String { "colgroup" }
  public var attributes: [HTMLAttribute<ColgroupHTMLAttribute>]
  public var content: Content
}
public func colgroup(_ attributes: HTMLAttribute<ColgroupHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> ColgroupHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func colgroup(_ attributes: [HTMLAttribute<ColgroupHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> ColgroupHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum TableHTMLAttribute {}
public struct TableHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = TableHTMLAttribute
  public static var name: String { "table" }
  public var attributes: [HTMLAttribute<TableHTMLAttribute>]
  public var content: Content
}
public func table(_ attributes: HTMLAttribute<TableHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> TableHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func table(_ attributes: [HTMLAttribute<TableHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> TableHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum TbodyHTMLAttribute {}
public struct TbodyHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = TbodyHTMLAttribute
  public static var name: String { "tbody" }
  public var attributes: [HTMLAttribute<TbodyHTMLAttribute>]
  public var content: Content
}
public func tbody(_ attributes: HTMLAttribute<TbodyHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> TbodyHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func tbody(_ attributes: [HTMLAttribute<TbodyHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> TbodyHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum TdHTMLAttribute {}
public struct TdHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = TdHTMLAttribute
  public static var name: String { "td" }
  public var attributes: [HTMLAttribute<TdHTMLAttribute>]
  public var content: Content
}
public func td(_ attributes: HTMLAttribute<TdHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> TdHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func td(_ attributes: [HTMLAttribute<TdHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> TdHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum TfootHTMLAttribute {}
public struct TfootHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = TfootHTMLAttribute
  public static var name: String { "tfoot" }
  public var attributes: [HTMLAttribute<TfootHTMLAttribute>]
  public var content: Content
}
public func tfoot(_ attributes: HTMLAttribute<TfootHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> TfootHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func tfoot(_ attributes: [HTMLAttribute<TfootHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> TfootHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum ThHTMLAttribute {}
public struct ThHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = ThHTMLAttribute
  public static var name: String { "th" }
  public var attributes: [HTMLAttribute<ThHTMLAttribute>]
  public var content: Content
}
public func th(_ attributes: HTMLAttribute<ThHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> ThHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func th(_ attributes: [HTMLAttribute<ThHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> ThHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum TheadHTMLAttribute {}
public struct TheadHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = TheadHTMLAttribute
  public static var name: String { "thead" }
  public var attributes: [HTMLAttribute<TheadHTMLAttribute>]
  public var content: Content
}
public func thead(_ attributes: HTMLAttribute<TheadHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> TheadHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func thead(_ attributes: [HTMLAttribute<TheadHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> TheadHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum TrHTMLAttribute {}
public struct TrHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = TrHTMLAttribute
  public static var name: String { "tr" }
  public var attributes: [HTMLAttribute<TrHTMLAttribute>]
  public var content: Content
}
public func tr(_ attributes: HTMLAttribute<TrHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> TrHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func tr(_ attributes: [HTMLAttribute<TrHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> TrHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

// MARK: - Forms

public enum ButtonHTMLAttribute {}
public struct ButtonHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = ButtonHTMLAttribute
  public static var name: String { "button" }
  public var attributes: [HTMLAttribute<ButtonHTMLAttribute>]
  public var content: Content
}
public func button(_ attributes: HTMLAttribute<ButtonHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> ButtonHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func button(_ attributes: [HTMLAttribute<ButtonHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> ButtonHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum DatalistHTMLAttribute {}
public struct DatalistHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = DatalistHTMLAttribute
  public static var name: String { "datalist" }
  public var attributes: [HTMLAttribute<DatalistHTMLAttribute>]
  public var content: Content
}
public func datalist(_ attributes: HTMLAttribute<DatalistHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> DatalistHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func datalist(_ attributes: [HTMLAttribute<DatalistHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> DatalistHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum FieldsetHTMLAttribute {}
public struct FieldsetHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = FieldsetHTMLAttribute
  public static var name: String { "fieldset" }
  public var attributes: [HTMLAttribute<FieldsetHTMLAttribute>]
  public var content: Content
}
public func fieldset(_ attributes: HTMLAttribute<FieldsetHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> FieldsetHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func fieldset(_ attributes: [HTMLAttribute<FieldsetHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> FieldsetHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum FormHTMLAttribute {}
public struct FormHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = FormHTMLAttribute
  public static var name: String { "form" }
  public var attributes: [HTMLAttribute<FormHTMLAttribute>]
  public var content: Content
}
public func form(_ attributes: HTMLAttribute<FormHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> FormHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func form(_ attributes: [HTMLAttribute<FormHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> FormHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum InputHTMLAttribute {}
public struct InputHTMLElement: HTMLElement {
  public typealias AttributesType = InputHTMLAttribute
  public static var name: String { "input" }
  public var attributes: [HTMLAttribute<InputHTMLAttribute>]
  public var content: some Node {}
}
public func input(_ attributes: HTMLAttribute<InputHTMLAttribute>...) -> InputHTMLElement {
  .init(attributes: attributes)
}
public func input(_ attributes: [HTMLAttribute<InputHTMLAttribute>]) -> InputHTMLElement {
  .init(attributes: attributes)
}

public enum LabelHTMLAttribute {}
public struct LabelHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = LabelHTMLAttribute
  public static var name: String { "label" }
  public var attributes: [HTMLAttribute<LabelHTMLAttribute>]
  public var content: Content
}
public func label(_ attributes: HTMLAttribute<LabelHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> LabelHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func label(_ attributes: [HTMLAttribute<LabelHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> LabelHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum LegendHTMLAttribute {}
public struct LegendHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = LegendHTMLAttribute
  public static var name: String { "legend" }
  public var attributes: [HTMLAttribute<LegendHTMLAttribute>]
  public var content: Content
}
public func legend(_ attributes: HTMLAttribute<LegendHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> LegendHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func legend(_ attributes: [HTMLAttribute<LegendHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> LegendHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum MeterHTMLAttribute {}
public struct MeterHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = MeterHTMLAttribute
  public static var name: String { "meter" }
  public var attributes: [HTMLAttribute<MeterHTMLAttribute>]
  public var content: Content
}
public func meter(_ attributes: HTMLAttribute<MeterHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> MeterHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func meter(_ attributes: [HTMLAttribute<MeterHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> MeterHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum OptgroupHTMLAttribute {}
public struct OptgroupHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = OptgroupHTMLAttribute
  public static var name: String { "optgroup" }
  public var attributes: [HTMLAttribute<OptgroupHTMLAttribute>]
  public var content: Content
}
public func optgroup(_ attributes: HTMLAttribute<OptgroupHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> OptgroupHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func optgroup(_ attributes: [HTMLAttribute<OptgroupHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> OptgroupHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum OptionHTMLAttribute {}
public struct OptionHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = OptionHTMLAttribute
  public static var name: String { "option" }
  public var attributes: [HTMLAttribute<OptionHTMLAttribute>]
  public var content: Content
}
public func option(_ attributes: HTMLAttribute<OptionHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> OptionHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func option(_ attributes: [HTMLAttribute<OptionHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> OptionHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum OutputHTMLAttribute {}
public struct OutputHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = OutputHTMLAttribute
  public static var name: String { "output" }
  public var attributes: [HTMLAttribute<OutputHTMLAttribute>]
  public var content: Content
}
public func output(_ attributes: HTMLAttribute<OutputHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> OutputHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func output(_ attributes: [HTMLAttribute<OutputHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> OutputHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum ProgressHTMLAttribute {}
public struct ProgressHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = ProgressHTMLAttribute
  public static var name: String { "progress" }
  public var attributes: [HTMLAttribute<ProgressHTMLAttribute>]
  public var content: Content
}
public func progress(_ attributes: HTMLAttribute<ProgressHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> ProgressHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func progress(_ attributes: [HTMLAttribute<ProgressHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> ProgressHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum SelectHTMLAttribute {}
public struct SelectHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = SelectHTMLAttribute
  public static var name: String { "select" }
  public var attributes: [HTMLAttribute<SelectHTMLAttribute>]
  public var content: Content
}
public func select(_ attributes: HTMLAttribute<SelectHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> SelectHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func select(_ attributes: [HTMLAttribute<SelectHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> SelectHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum TextareaHTMLAttribute {}
public struct TextareaHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = TextareaHTMLAttribute
  public static var name: String { "textarea" }
  public var attributes: [HTMLAttribute<TextareaHTMLAttribute>]
  public var content: Content
}
public func textarea(_ attributes: HTMLAttribute<TextareaHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> TextareaHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func textarea(_ attributes: [HTMLAttribute<TextareaHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> TextareaHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

// MARK: - Interactive Elements

public enum DetailsHTMLAttribute {}
public struct DetailsHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = DetailsHTMLAttribute
  public static var name: String { "details" }
  public var attributes: [HTMLAttribute<DetailsHTMLAttribute>]
  public var content: Content
}
public func details(_ attributes: HTMLAttribute<DetailsHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> DetailsHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func details(_ attributes: [HTMLAttribute<DetailsHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> DetailsHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum DialogHTMLAttribute {}
public struct DialogHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = DialogHTMLAttribute
  public static var name: String { "dialog" }
  public var attributes: [HTMLAttribute<DialogHTMLAttribute>]
  public var content: Content
}
public func dialog(_ attributes: HTMLAttribute<DialogHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> DialogHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func dialog(_ attributes: [HTMLAttribute<DialogHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> DialogHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum SummaryHTMLAttribute {}
public struct SummaryHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = SummaryHTMLAttribute
  public static var name: String { "summary" }
  public var attributes: [HTMLAttribute<SummaryHTMLAttribute>]
  public var content: Content
}
public func summary(_ attributes: HTMLAttribute<SummaryHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> SummaryHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func summary(_ attributes: [HTMLAttribute<SummaryHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> SummaryHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

// MARK: - Web Components

public enum SlotHTMLAttribute {}
public struct SlotHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = SlotHTMLAttribute
  public static var name: String { "slot" }
  public var attributes: [HTMLAttribute<SlotHTMLAttribute>]
  public var content: Content
}
public func slot(_ attributes: HTMLAttribute<SlotHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> SlotHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func slot(_ attributes: [HTMLAttribute<SlotHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> SlotHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

public enum TemplateHTMLAttribute {}
public struct TemplateHTMLElement<Content: Node>: HTMLElement {
  public typealias AttributesType = TemplateHTMLAttribute
  public static var name: String { "template" }
  public var attributes: [HTMLAttribute<TemplateHTMLAttribute>]
  public var content: Content
}
public func template(_ attributes: HTMLAttribute<TemplateHTMLAttribute>..., @HTMLBuilder content: () -> some Node) -> TemplateHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}
public func template(_ attributes: [HTMLAttribute<TemplateHTMLAttribute>], @HTMLBuilder content: () -> some Node) -> TemplateHTMLElement<some Node> {
  .init(attributes: attributes, content: content())
}

// MARK: -

package struct AnyHTMLElement<Wrapped: HTMLElement, Content: Node>: HTMLElement {
  package static var name: String { Wrapped.name }
  package var attributes: [HTMLAttribute<Wrapped.AttributesType>]
  package var content: Content
  package init(attributes: [HTMLAttribute<Wrapped.AttributesType>], content: Content) {
    self.attributes = attributes
    self.content = content
  }
}
