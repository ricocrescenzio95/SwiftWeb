import JavaScriptKit
import SwiftHTML

public protocol NativeElement<Element> {
  associatedtype Element
  static func makeNativeElement(from jsValue: JSValue) -> Element
}

public struct GenericHTMLNativeElement {
  public let element: JSObject
  
  init(_ element: JSValue) {
    self.element = element.object!
  }
}

// MARK: - Input Element

extension InputHTMLAttribute: NativeElement  {
  public static func makeNativeElement(from jsValue: JSValue) -> InputHTMLNativeElement {
    .init(jsValue)
  }
}

public struct InputHTMLNativeElement {
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

extension ButtonHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> ButtonHTMLNativeElement {
    .init(jsValue)
  }
}

public struct ButtonHTMLNativeElement {
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

extension FormHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> FormHTMLNativeElement {
    .init(jsValue)
  }
}

public struct FormHTMLNativeElement {
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

extension SelectHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> SelectHTMLNativeElement {
    .init(jsValue)
  }
}

public struct SelectHTMLNativeElement {
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

extension TextareaHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> TextareaHTMLNativeElement {
    .init(jsValue)
  }
}

public struct TextareaHTMLNativeElement {
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

extension OptionHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> OptionHTMLNativeElement {
    .init(jsValue)
  }
}

public struct OptionHTMLNativeElement {
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

extension DetailsHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> DetailsHTMLNativeElement {
    .init(jsValue)
  }
}

public struct DetailsHTMLNativeElement {
  public let jsDetails: JSObject
  
  public init(_ js: JSValue) {
    jsDetails = js.object!
  }
  
  public var open: Bool { jsDetails.open.boolean ?? false }
}

// MARK: - Dialog Element

extension DialogHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> DialogHTMLNativeElement {
    .init(jsValue)
  }
}

public struct DialogHTMLNativeElement {
  public let jsDialog: JSObject
  
  public init(_ js: JSValue) {
    jsDialog = js.object!
  }
  
  public var open: Bool { jsDialog.open.boolean ?? false }
  public var returnValue: String { jsDialog.returnValue.string ?? "" }
}

// MARK: - Video Element

extension VideoHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> VideoHTMLNativeElement {
    .init(jsValue)
  }
}

public struct VideoHTMLNativeElement {
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

extension AudioHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> AudioHTMLNativeElement {
    .init(jsValue)
  }
}

public struct AudioHTMLNativeElement {
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

extension CanvasHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement {
    .init(jsValue)
  }
}

// MARK: - Img Element

extension ImgHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> ImgHTMLNativeElement {
    .init(jsValue)
  }
}

public struct ImgHTMLNativeElement {
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

extension FieldsetHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement {
    .init(jsValue)
  }
}

// MARK: - Optgroup Element

extension OptgroupHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> OptgroupHTMLNativeElement {
    .init(jsValue)
  }
}

public struct OptgroupHTMLNativeElement {
  public let jsOptgroup: JSObject
  
  public init(_ js: JSValue) {
    jsOptgroup = js.object!
  }
  
  public var label: String { jsOptgroup.label.string ?? "" }
  public var disabled: Bool { jsOptgroup.disabled.boolean ?? false }
}

// MARK: - Label Element

extension LabelHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> LabelHTMLNativeElement {
    .init(jsValue)
  }
}

public struct LabelHTMLNativeElement {
  public let jsLabel: JSObject
  
  public init(_ js: JSValue) {
    jsLabel = js.object!
  }
  
  public var htmlFor: String { jsLabel.htmlFor.string ?? "" }
}

// MARK: - Meter Element

extension MeterHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> MeterHTMLNativeElement {
    .init(jsValue)
  }
}

public struct MeterHTMLNativeElement {
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

extension ProgressHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> ProgressHTMLNativeElement {
    .init(jsValue)
  }
}

public struct ProgressHTMLNativeElement {
  public let jsProgress: JSObject
  
  public init(_ js: JSValue) {
    jsProgress = js.object!
  }
  
  public var value: Double { jsProgress.value.number ?? 0 }
  public var max: Double { jsProgress.max.number ?? 1 }
}

// MARK: - Output Element

extension OutputHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> OutputHTMLNativeElement {
    .init(jsValue)
  }
}

public struct OutputHTMLNativeElement {
  public let jsOutput: JSObject
  
  public init(_ js: JSValue) {
    jsOutput = js.object!
  }
  
  public var value: String { jsOutput.value.string ?? "" }
}

// MARK: - A (Link) Element

extension AHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> AHTMLNativeElement {
    .init(jsValue)
  }
}

public struct AHTMLNativeElement {
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

extension IframeHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> IframeHTMLNativeElement {
    .init(jsValue)
  }
}

public struct IframeHTMLNativeElement {
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

extension AreaHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> AreaHTMLNativeElement {
    .init(jsValue)
  }
}

public struct AreaHTMLNativeElement {
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

extension TrackHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> TrackHTMLNativeElement {
    .init(jsValue)
  }
}

public struct TrackHTMLNativeElement {
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

extension ObjectHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> ObjectHTMLNativeElement {
    .init(jsValue)
  }
}

public struct ObjectHTMLNativeElement {
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

extension EmbedHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> EmbedHTMLNativeElement {
    .init(jsValue)
  }
}

public struct EmbedHTMLNativeElement {
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

extension SourceHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> SourceHTMLNativeElement {
    .init(jsValue)
  }
}

public struct SourceHTMLNativeElement {
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

extension ScriptHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> ScriptHTMLNativeElement {
    .init(jsValue)
  }
}

public struct ScriptHTMLNativeElement {
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

extension LinkHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> LinkHTMLNativeElement {
    .init(jsValue)
  }
}

public struct LinkHTMLNativeElement {
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

extension StyleHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> StyleHTMLNativeElement {
    .init(jsValue)
  }
}

public struct StyleHTMLNativeElement {
  public let jsStyle: JSObject
  
  public init(_ js: JSValue) {
    jsStyle = js.object!
  }
  
  public var type: String? { jsStyle.type.string }
  public var media: String? { jsStyle.media.string }
  public var disabled: Bool { jsStyle.disabled.boolean ?? false }
}

// MARK: - Map Element

extension MapHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement {
    .init(jsValue)
  }
}

// MARK: - Datalist Element

extension DatalistHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement {
    .init(jsValue)
  }
}

// MARK: - Slot Element

extension SlotHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement {
    .init(jsValue)
  }
}

// MARK: - Template Element

extension TemplateHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement {
    .init(jsValue)
  }
}

// MARK: - Generic Elements (using HTMLNativeElement)

// Document Metadata
extension HeadHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement { .init(jsValue) }
}

extension TitleHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement { .init(jsValue) }
}

extension BaseHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement { .init(jsValue) }
}

extension MetaHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement { .init(jsValue) }
}

// Sectioning Root
extension BodyHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement { .init(jsValue) }
}

// Content Sectioning
extension AddressHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement { .init(jsValue) }
}

extension ArticleHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement { .init(jsValue) }
}

extension AsideHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement { .init(jsValue) }
}

extension FooterHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement { .init(jsValue) }
}

extension HeaderHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement { .init(jsValue) }
}

extension H1HTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement { .init(jsValue) }
}

extension H2HTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement { .init(jsValue) }
}

extension H3HTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement { .init(jsValue) }
}

extension H4HTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement { .init(jsValue) }
}

extension H5HTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement { .init(jsValue) }
}

extension H6HTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement { .init(jsValue) }
}

extension HgroupHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement { .init(jsValue) }
}

extension MainHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement { .init(jsValue) }
}

extension NavHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement { .init(jsValue) }
}

extension SectionHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement { .init(jsValue) }
}

extension SearchHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement { .init(jsValue) }
}

// Text Content
extension BlockquoteHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement { .init(jsValue) }
}

extension DdHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement { .init(jsValue) }
}

extension DivHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement { .init(jsValue) }
}

extension DlHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement { .init(jsValue) }
}

extension DtHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement { .init(jsValue) }
}

extension FigcaptionHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement { .init(jsValue) }
}

extension FigureHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement { .init(jsValue) }
}

extension HrHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement { .init(jsValue) }
}

extension LiHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement { .init(jsValue) }
}

extension MenuHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement { .init(jsValue) }
}

extension OlHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement { .init(jsValue) }
}

extension PHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement { .init(jsValue) }
}

extension PreHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement { .init(jsValue) }
}

extension UlHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement { .init(jsValue) }
}

// Inline Text Semantics
extension AbbrHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement { .init(jsValue) }
}

extension BHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement { .init(jsValue) }
}

extension BdiHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement { .init(jsValue) }
}

extension BdoHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement { .init(jsValue) }
}

extension BrHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement { .init(jsValue) }
}

extension CiteHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement { .init(jsValue) }
}

extension CodeHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement { .init(jsValue) }
}

extension DataHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement { .init(jsValue) }
}

extension DfnHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement { .init(jsValue) }
}

extension EmHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement { .init(jsValue) }
}

extension IHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement { .init(jsValue) }
}

extension KbdHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement { .init(jsValue) }
}

extension MarkHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement { .init(jsValue) }
}

extension QHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement { .init(jsValue) }
}

extension RpHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement { .init(jsValue) }
}

extension RtHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement { .init(jsValue) }
}

extension RubyHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement { .init(jsValue) }
}

extension SHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement { .init(jsValue) }
}

extension SampHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement { .init(jsValue) }
}

extension SmallHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement { .init(jsValue) }
}

extension SpanHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement { .init(jsValue) }
}

extension StrongHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement { .init(jsValue) }
}

extension SubHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement { .init(jsValue) }
}

extension SupHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement { .init(jsValue) }
}

extension TimeHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement { .init(jsValue) }
}

extension UHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement { .init(jsValue) }
}

extension VarHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement { .init(jsValue) }
}

extension WbrHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement { .init(jsValue) }
}

// Embedded Content
extension PictureHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement { .init(jsValue) }
}

extension PortalHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement { .init(jsValue) }
}

// SVG and MathML
extension SvgHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement { .init(jsValue) }
}

extension MathHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement { .init(jsValue) }
}

// Scripting
extension NoscriptHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement { .init(jsValue) }
}

// Demarcating Edits
extension DelHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement { .init(jsValue) }
}

extension InsHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement { .init(jsValue) }
}

// Table Content
extension CaptionHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement { .init(jsValue) }
}

extension ColHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement { .init(jsValue) }
}

extension ColgroupHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement { .init(jsValue) }
}

extension TableHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement { .init(jsValue) }
}

extension TbodyHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement { .init(jsValue) }
}

extension TdHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement { .init(jsValue) }
}

extension TfootHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement { .init(jsValue) }
}

extension ThHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement { .init(jsValue) }
}

extension TheadHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement { .init(jsValue) }
}

extension TrHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement { .init(jsValue) }
}

// Forms (remaining)
extension LegendHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement { .init(jsValue) }
}

// Interactive Elements
extension SummaryHTMLAttribute: NativeElement {
  public static func makeNativeElement(from jsValue: JSValue) -> GenericHTMLNativeElement { .init(jsValue) }
}
