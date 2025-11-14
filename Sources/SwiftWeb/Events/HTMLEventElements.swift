import JavaScriptKit
import SwiftHTML

public protocol EventElement<Element> {
  associatedtype Element
  static func makeEventElement(from jsValue: JSValue) -> Element
}

public struct HTMLEventElement {
  public let element: JSObject
  
  init(_ element: JSValue) {
    self.element = element.object!
  }
}

// MARK: - Input Element

extension InputHTMLAttribute: EventElement  {
  public static func makeEventElement(from jsValue: JSValue) -> InputHTMLEventElement {
    .init(jsValue)
  }
}

public struct InputHTMLEventElement {
  public let jsInput: JSObject
  
  public init(_ js: JSValue) {
    jsInput = js.object!
  }
  
  public var value: String? { jsInput.value.string }
  public var checked: Bool { jsInput.checked.boolean ?? false }
  public var type: InputType { .init(rawValue: jsInput.type.string ?? "text") ?? .text }
  public var name: String? { jsInput.name.string }
  public var disabled: Bool { jsInput.disabled.boolean ?? false }
  public var readonly: Bool { jsInput.readOnly.boolean ?? false }
  public var required: Bool { jsInput.required.boolean ?? false }
}

// MARK: - Button Element

extension ButtonHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> ButtonHTMLEventElement {
    .init(jsValue)
  }
}

public struct ButtonHTMLEventElement {
  public let jsButton: JSObject
  
  public init(_ js: JSValue) {
    jsButton = js.object!
  }
  
  public var value: String { jsButton.value.string ?? "" }
  public var type: ButtonType { .init(rawValue: jsButton.type.string ?? "submit") ?? .submit }
  public var disabled: Bool { jsButton.disabled.boolean ?? false }
  public var name: String? { jsButton.name.string }
}

// MARK: - Form Element

extension FormHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> FormHTMLEventElement {
    .init(jsValue)
  }
}

public struct FormHTMLEventElement {
  public let jsForm: JSObject
  
  public init(_ js: JSValue) {
    jsForm = js.object!
  }
  
  public var action: String { jsForm.action.string ?? "" }
  public var method: String { jsForm.method.string ?? "get" }
  public var enctype: String { jsForm.enctype.string ?? "application/x-www-form-urlencoded" }
  public var target: String? { jsForm.target.string }
  public var name: String? { jsForm.name.string }
}

// MARK: - Select Element

extension SelectHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> SelectHTMLEventElement {
    .init(jsValue)
  }
}

public struct SelectHTMLEventElement {
  public let jsSelect: JSObject
  
  public init(_ js: JSValue) {
    jsSelect = js.object!
  }
  
  public var value: String { jsSelect.value.string ?? "" }
  public var selectedIndex: Int { Int(jsSelect.selectedIndex.number ?? -1) }
  public var multiple: Bool { jsSelect.multiple.boolean ?? false }
  public var disabled: Bool { jsSelect.disabled.boolean ?? false }
  public var name: String? { jsSelect.name.string }
  public var required: Bool { jsSelect.required.boolean ?? false }
}

// MARK: - Textarea Element

extension TextareaHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> TextareaHTMLEventElement {
    .init(jsValue)
  }
}

public struct TextareaHTMLEventElement {
  public let jsTextarea: JSObject
  
  public init(_ js: JSValue) {
    jsTextarea = js.object!
  }
  
  public var value: String { jsTextarea.value.string ?? "" }
  public var disabled: Bool { jsTextarea.disabled.boolean ?? false }
  public var rows: Int { Int(jsTextarea.rows.number ?? 0) }
  public var cols: Int { Int(jsTextarea.cols.number ?? 0) }
  public var name: String? { jsTextarea.name.string }
  public var readonly: Bool { jsTextarea.readOnly.boolean ?? false }
  public var required: Bool { jsTextarea.required.boolean ?? false }
}

// MARK: - Option Element

extension OptionHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> OptionHTMLEventElement {
    .init(jsValue)
  }
}

public struct OptionHTMLEventElement {
  public let jsOption: JSObject
  
  public init(_ js: JSValue) {
    jsOption = js.object!
  }
  
  public var value: String { jsOption.value.string ?? "" }
  public var text: String { jsOption.text.string ?? "" }
  public var selected: Bool { jsOption.selected.boolean ?? false }
  public var disabled: Bool { jsOption.disabled.boolean ?? false }
}

// MARK: - Details Element

extension DetailsHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> DetailsHTMLEventElement {
    .init(jsValue)
  }
}

public struct DetailsHTMLEventElement {
  public let jsDetails: JSObject
  
  public init(_ js: JSValue) {
    jsDetails = js.object!
  }
  
  public var open: Bool { jsDetails.open.boolean ?? false }
}

// MARK: - Dialog Element

extension DialogHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> DialogHTMLEventElement {
    .init(jsValue)
  }
}

public struct DialogHTMLEventElement {
  public let jsDialog: JSObject
  
  public init(_ js: JSValue) {
    jsDialog = js.object!
  }
  
  public var open: Bool { jsDialog.open.boolean ?? false }
  public var returnValue: String { jsDialog.returnValue.string ?? "" }
}

// MARK: - Video Element

extension VideoHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> VideoHTMLEventElement {
    .init(jsValue)
  }
}

public struct VideoHTMLEventElement {
  public let jsVideo: JSObject
  
  public init(_ js: JSValue) {
    jsVideo = js.object!
  }
  
  public var currentTime: Double { jsVideo.currentTime.number ?? 0 }
  public var duration: Double? { jsVideo.duration.number }
  public var paused: Bool { jsVideo.paused.boolean ?? true }
  public var muted: Bool { jsVideo.muted.boolean ?? false }
  public var volume: Double { jsVideo.volume.number ?? 1.0 }
  public var ended: Bool { jsVideo.ended.boolean ?? false }
  public var src: String? { jsVideo.src.string }
  public var readyState: Int { Int(jsVideo.readyState.number ?? 0) }
}

// MARK: - Audio Element

extension AudioHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> AudioHTMLEventElement {
    .init(jsValue)
  }
}

public struct AudioHTMLEventElement {
  public let jsAudio: JSObject
  
  public init(_ js: JSValue) {
    jsAudio = js.object!
  }
  
  public var currentTime: Double { jsAudio.currentTime.number ?? 0 }
  public var duration: Double? { jsAudio.duration.number }
  public var paused: Bool { jsAudio.paused.boolean ?? true }
  public var muted: Bool { jsAudio.muted.boolean ?? false }
  public var volume: Double { jsAudio.volume.number ?? 1.0 }
  public var ended: Bool { jsAudio.ended.boolean ?? false }
  public var src: String? { jsAudio.src.string }
  public var readyState: Int { Int(jsAudio.readyState.number ?? 0) }
}

// MARK: - Canvas Element

extension CanvasHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement {
    .init(jsValue)
  }
}

// MARK: - Img Element

extension ImgHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> ImgHTMLEventElement {
    .init(jsValue)
  }
}

public struct ImgHTMLEventElement {
  public let jsImg: JSObject
  
  public init(_ js: JSValue) {
    jsImg = js.object!
  }
  
  public var src: String? { jsImg.src.string }
  public var alt: String? { jsImg.alt.string }
  public var width: Int { Int(jsImg.width.number ?? 0) }
  public var height: Int { Int(jsImg.height.number ?? 0) }
  public var complete: Bool { jsImg.complete.boolean ?? false }
  public var naturalWidth: Int { Int(jsImg.naturalWidth.number ?? 0) }
  public var naturalHeight: Int { Int(jsImg.naturalHeight.number ?? 0) }
}

// MARK: - Fieldset Element

extension FieldsetHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement {
    .init(jsValue)
  }
}

// MARK: - Optgroup Element

extension OptgroupHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> OptgroupHTMLEventElement {
    .init(jsValue)
  }
}

public struct OptgroupHTMLEventElement {
  public let jsOptgroup: JSObject
  
  public init(_ js: JSValue) {
    jsOptgroup = js.object!
  }
  
  public var label: String { jsOptgroup.label.string ?? "" }
  public var disabled: Bool { jsOptgroup.disabled.boolean ?? false }
}

// MARK: - Label Element

extension LabelHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> LabelHTMLEventElement {
    .init(jsValue)
  }
}

public struct LabelHTMLEventElement {
  public let jsLabel: JSObject
  
  public init(_ js: JSValue) {
    jsLabel = js.object!
  }
  
  public var htmlFor: String { jsLabel.htmlFor.string ?? "" }
}

// MARK: - Meter Element

extension MeterHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> MeterHTMLEventElement {
    .init(jsValue)
  }
}

public struct MeterHTMLEventElement {
  public let jsMeter: JSObject
  
  public init(_ js: JSValue) {
    jsMeter = js.object!
  }
  
  public var value: Double { jsMeter.value.number ?? 0 }
  public var min: Double { jsMeter.min.number ?? 0 }
  public var max: Double { jsMeter.max.number ?? 1 }
  public var low: Double { jsMeter.low.number ?? 0 }
  public var high: Double { jsMeter.high.number ?? 1 }
  public var optimum: Double { jsMeter.optimum.number ?? 0.5 }
}

// MARK: - Progress Element

extension ProgressHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> ProgressHTMLEventElement {
    .init(jsValue)
  }
}

public struct ProgressHTMLEventElement {
  public let jsProgress: JSObject
  
  public init(_ js: JSValue) {
    jsProgress = js.object!
  }
  
  public var value: Double { jsProgress.value.number ?? 0 }
  public var max: Double { jsProgress.max.number ?? 1 }
}

// MARK: - Output Element

extension OutputHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> OutputHTMLEventElement {
    .init(jsValue)
  }
}

public struct OutputHTMLEventElement {
  public let jsOutput: JSObject
  
  public init(_ js: JSValue) {
    jsOutput = js.object!
  }
  
  public var value: String { jsOutput.value.string ?? "" }
}

// MARK: - A (Link) Element

extension AHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> AHTMLEventElement {
    .init(jsValue)
  }
}

public struct AHTMLEventElement {
  public let jsAnchor: JSObject
  
  public init(_ js: JSValue) {
    jsAnchor = js.object!
  }
  
  public var href: String? { jsAnchor.href.string }
  public var target: String? { jsAnchor.target.string }
  public var text: String { jsAnchor.text.string ?? "" }
  public var download: String? { jsAnchor.download.string }
  public var rel: String? { jsAnchor.rel.string }
}

// MARK: - Iframe Element

extension IframeHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> IframeHTMLEventElement {
    .init(jsValue)
  }
}

public struct IframeHTMLEventElement {
  public let jsIframe: JSObject
  
  public init(_ js: JSValue) {
    jsIframe = js.object!
  }
  
  public var src: String? { jsIframe.src.string }
  public var width: String? { jsIframe.width.string }
  public var height: String? { jsIframe.height.string }
  public var name: String? { jsIframe.name.string }
}

// MARK: - Area Element

extension AreaHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> AreaHTMLEventElement {
    .init(jsValue)
  }
}

public struct AreaHTMLEventElement {
  public let jsArea: JSObject
  
  public init(_ js: JSValue) {
    jsArea = js.object!
  }
  
  public var href: String? { jsArea.href.string }
  public var alt: String? { jsArea.alt.string }
  public var coords: String? { jsArea.coords.string }
  public var shape: String? { jsArea.shape.string }
  public var target: String? { jsArea.target.string }
}

// MARK: - Track Element

extension TrackHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> TrackHTMLEventElement {
    .init(jsValue)
  }
}

public struct TrackHTMLEventElement {
  public let jsTrack: JSObject
  
  public init(_ js: JSValue) {
    jsTrack = js.object!
  }
  
  public var kind: String? { jsTrack.kind.string }
  public var label: String? { jsTrack.label.string }
  public var src: String? { jsTrack.src.string }
  public var srclang: String? { jsTrack.srclang.string }
  public var readyState: Int { Int(jsTrack.readyState.number ?? 0) }
}

// MARK: - Object Element

extension ObjectHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> ObjectHTMLEventElement {
    .init(jsValue)
  }
}

public struct ObjectHTMLEventElement {
  public let jsObject: JSObject
  
  public init(_ js: JSValue) {
    jsObject = js.object!
  }
  
  public var data: String? { jsObject.data.string }
  public var type: String? { jsObject.type.string }
  public var width: String? { jsObject.width.string }
  public var height: String? { jsObject.height.string }
}

// MARK: - Embed Element

extension EmbedHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> EmbedHTMLEventElement {
    .init(jsValue)
  }
}

public struct EmbedHTMLEventElement {
  public let jsEmbed: JSObject
  
  public init(_ js: JSValue) {
    jsEmbed = js.object!
  }
  
  public var src: String? { jsEmbed.src.string }
  public var type: String? { jsEmbed.type.string }
  public var width: String? { jsEmbed.width.string }
  public var height: String? { jsEmbed.height.string }
}

// MARK: - Source Element

extension SourceHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> SourceHTMLEventElement {
    .init(jsValue)
  }
}

public struct SourceHTMLEventElement {
  public let jsSource: JSObject
  
  public init(_ js: JSValue) {
    jsSource = js.object!
  }
  
  public var src: String? { jsSource.src.string }
  public var type: String? { jsSource.type.string }
  public var media: String? { jsSource.media.string }
  public var srcset: String? { jsSource.srcset.string }
  public var sizes: String? { jsSource.sizes.string }
}

// MARK: - Script Element

extension ScriptHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> ScriptHTMLEventElement {
    .init(jsValue)
  }
}

public struct ScriptHTMLEventElement {
  public let jsScript: JSObject
  
  public init(_ js: JSValue) {
    jsScript = js.object!
  }
  
  public var src: String? { jsScript.src.string }
  public var type: String? { jsScript.type.string }
  public var async: Bool { jsScript.async.boolean ?? false }
  public var `defer`: Bool { jsScript.defer.boolean ?? false }
  public var text: String? { jsScript.text.string }
}

// MARK: - Link Element

extension LinkHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> LinkHTMLEventElement {
    .init(jsValue)
  }
}

public struct LinkHTMLEventElement {
  public let jsLink: JSObject
  
  public init(_ js: JSValue) {
    jsLink = js.object!
  }
  
  public var href: String? { jsLink.href.string }
  public var rel: String? { jsLink.rel.string }
  public var type: String? { jsLink.type.string }
  public var media: String? { jsLink.media.string }
  public var disabled: Bool { jsLink.disabled.boolean ?? false }
}

// MARK: - Style Element

extension StyleHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> StyleHTMLEventElement {
    .init(jsValue)
  }
}

public struct StyleHTMLEventElement {
  public let jsStyle: JSObject
  
  public init(_ js: JSValue) {
    jsStyle = js.object!
  }
  
  public var type: String? { jsStyle.type.string }
  public var media: String? { jsStyle.media.string }
  public var disabled: Bool { jsStyle.disabled.boolean ?? false }
}

// MARK: - Map Element

extension MapHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement {
    .init(jsValue)
  }
}

// MARK: - Datalist Element

extension DatalistHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement {
    .init(jsValue)
  }
}

// MARK: - Slot Element

extension SlotHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement {
    .init(jsValue)
  }
}

// MARK: - Template Element

extension TemplateHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement {
    .init(jsValue)
  }
}

// MARK: - Generic Elements (using HTMLEventElement)

// Document Metadata
extension HeadHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement { .init(jsValue) }
}

extension TitleHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement { .init(jsValue) }
}

extension BaseHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement { .init(jsValue) }
}

extension MetaHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement { .init(jsValue) }
}

// Sectioning Root
extension BodyHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement { .init(jsValue) }
}

// Content Sectioning
extension AddressHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement { .init(jsValue) }
}

extension ArticleHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement { .init(jsValue) }
}

extension AsideHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement { .init(jsValue) }
}

extension FooterHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement { .init(jsValue) }
}

extension HeaderHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement { .init(jsValue) }
}

extension H1HTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement { .init(jsValue) }
}

extension H2HTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement { .init(jsValue) }
}

extension H3HTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement { .init(jsValue) }
}

extension H4HTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement { .init(jsValue) }
}

extension H5HTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement { .init(jsValue) }
}

extension H6HTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement { .init(jsValue) }
}

extension HgroupHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement { .init(jsValue) }
}

extension MainHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement { .init(jsValue) }
}

extension NavHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement { .init(jsValue) }
}

extension SectionHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement { .init(jsValue) }
}

extension SearchHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement { .init(jsValue) }
}

// Text Content
extension BlockquoteHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement { .init(jsValue) }
}

extension DdHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement { .init(jsValue) }
}

extension DivHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement { .init(jsValue) }
}

extension DlHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement { .init(jsValue) }
}

extension DtHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement { .init(jsValue) }
}

extension FigcaptionHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement { .init(jsValue) }
}

extension FigureHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement { .init(jsValue) }
}

extension HrHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement { .init(jsValue) }
}

extension LiHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement { .init(jsValue) }
}

extension MenuHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement { .init(jsValue) }
}

extension OlHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement { .init(jsValue) }
}

extension PHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement { .init(jsValue) }
}

extension PreHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement { .init(jsValue) }
}

extension UlHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement { .init(jsValue) }
}

// Inline Text Semantics
extension AbbrHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement { .init(jsValue) }
}

extension BHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement { .init(jsValue) }
}

extension BdiHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement { .init(jsValue) }
}

extension BdoHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement { .init(jsValue) }
}

extension BrHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement { .init(jsValue) }
}

extension CiteHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement { .init(jsValue) }
}

extension CodeHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement { .init(jsValue) }
}

extension DataHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement { .init(jsValue) }
}

extension DfnHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement { .init(jsValue) }
}

extension EmHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement { .init(jsValue) }
}

extension IHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement { .init(jsValue) }
}

extension KbdHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement { .init(jsValue) }
}

extension MarkHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement { .init(jsValue) }
}

extension QHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement { .init(jsValue) }
}

extension RpHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement { .init(jsValue) }
}

extension RtHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement { .init(jsValue) }
}

extension RubyHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement { .init(jsValue) }
}

extension SHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement { .init(jsValue) }
}

extension SampHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement { .init(jsValue) }
}

extension SmallHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement { .init(jsValue) }
}

extension SpanHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement { .init(jsValue) }
}

extension StrongHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement { .init(jsValue) }
}

extension SubHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement { .init(jsValue) }
}

extension SupHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement { .init(jsValue) }
}

extension TimeHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement { .init(jsValue) }
}

extension UHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement { .init(jsValue) }
}

extension VarHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement { .init(jsValue) }
}

extension WbrHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement { .init(jsValue) }
}

// Embedded Content
extension PictureHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement { .init(jsValue) }
}

extension PortalHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement { .init(jsValue) }
}

// SVG and MathML
extension SvgHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement { .init(jsValue) }
}

extension MathHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement { .init(jsValue) }
}

// Scripting
extension NoscriptHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement { .init(jsValue) }
}

// Demarcating Edits
extension DelHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement { .init(jsValue) }
}

extension InsHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement { .init(jsValue) }
}

// Table Content
extension CaptionHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement { .init(jsValue) }
}

extension ColHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement { .init(jsValue) }
}

extension ColgroupHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement { .init(jsValue) }
}

extension TableHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement { .init(jsValue) }
}

extension TbodyHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement { .init(jsValue) }
}

extension TdHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement { .init(jsValue) }
}

extension TfootHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement { .init(jsValue) }
}

extension ThHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement { .init(jsValue) }
}

extension TheadHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement { .init(jsValue) }
}

extension TrHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement { .init(jsValue) }
}

// Forms (remaining)
extension LegendHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement { .init(jsValue) }
}

// Interactive Elements
extension SummaryHTMLAttribute: EventElement {
  public static func makeEventElement(from jsValue: JSValue) -> HTMLEventElement { .init(jsValue) }
}
