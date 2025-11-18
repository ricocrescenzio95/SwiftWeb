// MARK: - Enums for Attribute Values

public enum Dir: String { case ltr, rtl, auto }
public enum ContentEditable: String { case `true`, `false`, plaintextOnly = "plaintext-only" }
public enum EnterKeyHint: String { case enter, done, go, next, previous, search, send }
public enum InputMode: String { case none, text, tel, url, email, numeric, decimal, search }
public enum Translate: String { case yes, no }

public enum InputType: String {
  case button, checkbox, color, date, datetimeLocal = "datetime-local"
  case email, file, hidden, image, month, number, password
  case radio, range, reset, search, submit, tel, text, time, url, week
}

public enum ButtonType: String { case button, reset, submit }
public enum FormMethod: String { case get, post, dialog }
public enum FormEnctype: String {
  case urlencoded = "application/x-www-form-urlencoded"
  case multipart = "multipart/form-data"
  case text = "text/plain"
}
public enum Autocomplete: String { case on, off }
public enum Preload: String { case none, metadata, auto }
public enum CrossOrigin: String { case anonymous, useCredentials = "use-credentials" }
public enum Decoding: String { case sync, async, auto }
public enum Loading: String { case eager, lazy }
public enum FetchPriority: String { case high, low, auto }
public enum ReferrerPolicy: String {
  case noReferrer = "no-referrer"
  case noReferrerWhenDowngrade = "no-referrer-when-downgrade"
  case origin, originWhenCrossOrigin = "origin-when-cross-origin"
  case sameOrigin = "same-origin"
  case strictOrigin = "strict-origin"
  case strictOriginWhenCrossOrigin = "strict-origin-when-cross-origin"
  case unsafeUrl = "unsafe-url"
}
public enum Scope: String { case row, col, rowgroup, colgroup }
public enum Shape: String { case rect, circle, poly, `default` }
public enum Target: String { case _blank = "_blank", _self = "_self", _parent = "_parent", _top = "_top" }
public enum Wrap: String { case soft, hard, off }
public enum TrackKind: String { case subtitles, captions, descriptions, chapters, metadata }
public enum Sandbox: String {
  case allowForms = "allow-forms"
  case allowModals = "allow-modals"
  case allowOrientationLock = "allow-orientation-lock"
  case allowPointerLock = "allow-pointer-lock"
  case allowPopups = "allow-popups"
  case allowPopupsToEscapeSandbox = "allow-popups-to-escape-sandbox"
  case allowPresentation = "allow-presentation"
  case allowSameOrigin = "allow-same-origin"
  case allowScripts = "allow-scripts"
  case allowTopNavigation = "allow-top-navigation"
  case allowTopNavigationByUserActivation = "allow-top-navigation-by-user-activation"
}

public enum RelValue: String {
  case alternate, author, bookmark, canonical, dnsPrefetch = "dns-prefetch"
  case `external` = "external", help, icon, license, manifest, me, modulepreload
  case next, nofollow, noopener, noreferrer, opener, pingback, preconnect
  case prefetch, preload, prerender, prev, search, stylesheet, tag
}

public enum InputModeValue: String {
  case none, text, decimal, numeric, tel, search, email, url
}

// MARK: - HTMLAttribute

public struct HTMLAttribute<AttributeType> {
  public let key: String
  public let value: String?
  
  private init(key: String, value: String?) {
    self.key = key
    self.value = value
  }
  
  public static func rawHTML(key: String, value: String?) -> Self { .init(key: key, value: value) }
}

// MARK: - Global Attributes
// These attributes can be used on any HTML element

public extension HTMLAttribute {
  // Core global attributes
  static func accesskey(_ v: String) -> Self { .init(key: "accesskey", value: v) }
  static func autocapitalize(_ v: String) -> Self { .init(key: "autocapitalize", value: v) }
  static func autofocus(_ on: Bool) -> Self { .init(key: "autofocus", value: on ? "true" : "false") }
  static var autofocus: Self { .autofocus(true) }
  static func `class`(_ classes: [String]) -> Self { .init(key: "class", value: classes.joined(separator: " ")) }
  static func `class`(_ class: String...) -> Self { .init(key: "class", value: `class`.joined(separator: " ")) }
  static func contenteditable(_ mode: ContentEditable) -> Self { .init(key: "contenteditable", value: mode.rawValue) }
  static func dir(_ v: Dir) -> Self { .init(key: "dir", value: v.rawValue) }
  static func draggable(_ on: Bool) -> Self { .init(key: "draggable", value: on ? "true" : "false") }
  static func enterkeyhint(_ v: EnterKeyHint) -> Self { .init(key: "enterkeyhint", value: v.rawValue) }
  static func hidden(_ on: Bool) -> Self { .init(key: "hidden", value: on ? "true" : "false") }
  static var hidden: Self { .hidden(true) }
  static func id(_ v: String) -> Self { .init(key: "id", value: v) }
  static func inert(_ on: Bool) -> Self { .init(key: "inert", value: on ? "true" : "false") }
  static var inert: Self { .inert(true) }
  static func inputmode(_ v: InputMode) -> Self { .init(key: "inputmode", value: v.rawValue) }
  static func is_(_ v: String) -> Self { .init(key: "is", value: v) }
  static func lang(_ v: String) -> Self { .init(key: "lang", value: v) }
  static func nonce(_ v: String) -> Self { .init(key: "nonce", value: v) }
  static func part(_ tokens: [String]) -> Self { .init(key: "part", value: tokens.joined(separator: " ")) }
  static func popover(_ on: Bool) -> Self { .init(key: "popover", value: on ? "true" : "false") }
  static var popover: Self { .popover(true) }
  static func slot(_ v: String) -> Self { .init(key: "slot", value: v) }
  static func spellcheck(_ on: Bool) -> Self { .init(key: "spellcheck", value: on ? "true" : "false") }
  static func style(_ css: CSS.Property...) -> Self { .init(key: "style", value: CSS.Body(css).cssValue) }
  static func style(_ css: [CSS.Property]) -> Self { .init(key: "style", value: CSS.Body(css).cssValue) }
  static func tabindex(_ i: Int) -> Self { .init(key: "tabindex", value: String(i)) }
  static func title(_ v: String) -> Self { .init(key: "title", value: v) }
  static func translate(_ v: Translate) -> Self { .init(key: "translate", value: v.rawValue) }
  
  // Microdata attributes
  static func itemid(_ v: String) -> Self { .init(key: "itemid", value: v) }
  static func itemprop(_ tokens: [String]) -> Self { .init(key: "itemprop", value: tokens.joined(separator: " ")) }
  static func itemref(_ ids: [String]) -> Self { .init(key: "itemref", value: ids.joined(separator: " ")) }
  static func itemscope(_ on: Bool) -> Self { .init(key: "itemscope", value: on ? "true" : "false") }
  static var itemscope: Self { .itemscope(true) }
  static func itemtype(_ urls: [String]) -> Self { .init(key: "itemtype", value: urls.joined(separator: " ")) }
  
  // ARIA and data attributes
  static func role(_ v: String) -> Self { .init(key: "role", value: v) }
  static func aria(_ name: String, _ v: String) -> Self { .init(key: "aria-\(name)", value: v) }
  static func data(_ name: String, _ v: String) -> Self { .init(key: "data-\(name)", value: v) }
}

// MARK: - Common Attributes Used Across Multiple Elements

public extension HTMLAttribute {
  // Links and navigation
  static func href(_ v: String) -> Self { .init(key: "href", value: v) }
  static func target(_ v: Target) -> Self { .init(key: "target", value: v.rawValue) }
  static func target(_ v: String) -> Self { .init(key: "target", value: v) }
  static func download(_ filename: String? = nil) -> Self { .init(key: "download", value: filename ?? "") }
  static func rel(_ v: RelValue) -> Self { .init(key: "rel", value: v.rawValue) }
  static func rel(_ v: String) -> Self { .init(key: "rel", value: v) }
  static func rel(_ values: [RelValue]) -> Self { .init(key: "rel", value: values.map(\.rawValue).joined(separator: " ")) }
  
  // Media attributes
  static func src(_ v: String) -> Self { .init(key: "src", value: v) }
  static func alt(_ v: String) -> Self { .init(key: "alt", value: v) }
  
  // Metadata
  static func charset(_ v: String) -> Self { .init(key: "charset", value: v) }
  static func name(_ v: String) -> Self { .init(key: "name", value: v) }
  static func content(_ v: String) -> Self { .init(key: "content", value: v) }
  static func httpEquiv(_ v: String) -> Self { .init(key: "http-equiv", value: v) }
  
  // Dimensions
  static func width(_ v: some Numeric) -> Self { .init(key: "width", value: "\(v)") }
  static func width(_ v: String) -> Self { .init(key: "width", value: v) }
  static func height(_ v: some Numeric) -> Self { .init(key: "height", value: "\(v)") }
  static func height(_ v: String) -> Self { .init(key: "height", value: v) }
  
  // Text content
  static func value(_ v: some Numeric) -> Self { .init(key: "value", value: "\(v)") }
  static func value(_ v: String) -> Self { .init(key: "value", value: v) }
  static func placeholder(_ v: String) -> Self { .init(key: "placeholder", value: v) }
  
  // Dates and times
  static func datetime(_ v: String) -> Self { .init(key: "datetime", value: v) }
  
  // Quotes and citations
  static func cite(_ v: String) -> Self { .init(key: "cite", value: v) }
  
  // Text direction and editing
  static func contenteditable(_ on: Bool) -> Self { .init(key: "contenteditable", value: on ? "true" : "false") }
  
  // Attributes for specific elements that can appear on multiple types
  static func selected(_ on: Bool) -> Self { .init(key: "selected", value: on ? "true" : "false") }
  static var selected: Self { .selected(true) }
  static func `for`(_ v: String) -> Self { .init(key: "for", value: v) }
  static func label(_ v: String) -> Self { .init(key: "label", value: v) }
  static func span(_ v: some BinaryInteger) -> Self { .init(key: "span", value: "\(v)") }
  
  // Additional common attributes
  static func accept(_ v: String) -> Self { .init(key: "accept", value: v) }
  static func autocomplete(_ v: String) -> Self { .init(key: "autocomplete", value: v) }
  static func cols(_ v: some BinaryInteger) -> Self { .init(key: "cols", value: "\(v)") }
  static func rows(_ v: some BinaryInteger) -> Self { .init(key: "rows", value: "\(v)") }
  static func max(_ v: some Numeric) -> Self { .init(key: "max", value: "\(v)") }
  static func max(_ v: String) -> Self { .init(key: "max", value: v) }
  static func min(_ v: some Numeric) -> Self { .init(key: "min", value: "\(v)") }
  static func min(_ v: String) -> Self { .init(key: "min", value: v) }
  static func high(_ v: some Numeric) -> Self { .init(key: "high", value: "\(v)") }
  static func high(_ v: String) -> Self { .init(key: "high", value: v) }
  static func low(_ v: some Numeric) -> Self { .init(key: "low", value: "\(v)") }
  static func low(_ v: String) -> Self { .init(key: "low", value: v) }
  static func optimum(_ v: some Numeric) -> Self { .init(key: "optimum", value: "\(v)") }
  static func optimum(_ v: String) -> Self { .init(key: "optimum", value: v) }
  static func wrap(_ v: Wrap) -> Self { .init(key: "wrap", value: v.rawValue) }
  static func coords(_ v: String) -> Self { .init(key: "coords", value: v) }
  static func shape(_ v: Shape) -> Self { .init(key: "shape", value: v.rawValue) }
  static func usemap(_ v: String) -> Self { .init(key: "usemap", value: v) }
}

// MARK: - Input Element Attributes

public extension HTMLAttribute where AttributeType == InputHTMLAttribute {
  static func type(_ v: InputType) -> Self { .init(key: "type", value: v.rawValue) }
  static func accept(_ v: String) -> Self { .init(key: "accept", value: v) }
  static func autocomplete(_ v: Autocomplete) -> Self { .init(key: "autocomplete", value: v.rawValue) }
  static func autocomplete(_ v: String) -> Self { .init(key: "autocomplete", value: v) }
  static func capture(_ v: String) -> Self { .init(key: "capture", value: v) }
  static func checked(_ on: Bool) -> Self { .init(key: "checked", value: on ? "true" : "false") }
  static var checked: Self { .checked(true) }
  static func dirname(_ v: String) -> Self { .init(key: "dirname", value: v) }
  static func disabled(_ on: Bool) -> Self { .init(key: "disabled", value: on ? "true" : "false") }
  static var disabled: Self { .disabled(true) }
  static func form(_ v: String) -> Self { .init(key: "form", value: v) }
  static func formaction(_ v: String) -> Self { .init(key: "formaction", value: v) }
  static func formenctype(_ v: FormEnctype) -> Self { .init(key: "formenctype", value: v.rawValue) }
  static func formmethod(_ v: FormMethod) -> Self { .init(key: "formmethod", value: v.rawValue) }
  static func formnovalidate(_ on: Bool) -> Self { .init(key: "formnovalidate", value: on ? "true" : "false") }
  static var formnovalidate: Self { .formnovalidate(true) }
  static func formtarget(_ v: Target) -> Self { .init(key: "formtarget", value: v.rawValue) }
  static func list(_ v: String) -> Self { .init(key: "list", value: v) }
  static func max(_ v: some Numeric) -> Self { .init(key: "max", value: "\(v)") }
  static func max(_ v: String) -> Self { .init(key: "max", value: v) }
  static func maxlength(_ v: some BinaryInteger) -> Self { .init(key: "maxlength", value: "\(v)") }
  static func min(_ v: some Numeric) -> Self { .init(key: "min", value: "\(v)") }
  static func min(_ v: String) -> Self { .init(key: "min", value: v) }
  static func minlength(_ v: some BinaryInteger) -> Self { .init(key: "minlength", value: "\(v)") }
  static func multiple(_ on: Bool) -> Self { .init(key: "multiple", value: on ? "true" : "false") }
  static var multiple: Self { .multiple(true) }
  static func pattern(_ v: String) -> Self { .init(key: "pattern", value: v) }
  static func readonly(_ on: Bool) -> Self { .init(key: "readonly", value: on ? "true" : "false") }
  static var readonly: Self { .readonly(true) }
  static func required(_ on: Bool) -> Self { .init(key: "required", value: on ? "true" : "false") }
  static var required: Self { .required(true) }
  static func size(_ v: some Numeric) -> Self { .init(key: "size", value: "\(v)") }
  static func step(_ v: some Numeric) -> Self { .init(key: "step", value: "\(v)") }
  static func step(_ v: String) -> Self { .init(key: "step", value: v) }
}

// MARK: - Button Element Attributes

public extension HTMLAttribute where AttributeType == ButtonHTMLAttribute {
  static func type(_ v: ButtonType) -> Self { .init(key: "type", value: v.rawValue) }
  static func disabled(_ on: Bool) -> Self { .init(key: "disabled", value: on ? "true" : "false") }
  static var disabled: Self { .disabled(true) }
  static func form(_ v: String) -> Self { .init(key: "form", value: v) }
  static func formaction(_ v: String) -> Self { .init(key: "formaction", value: v) }
  static func formenctype(_ v: FormEnctype) -> Self { .init(key: "formenctype", value: v.rawValue) }
  static func formmethod(_ v: FormMethod) -> Self { .init(key: "formmethod", value: v.rawValue) }
  static func formnovalidate(_ on: Bool) -> Self { .init(key: "formnovalidate", value: on ? "true" : "false") }
  static var formnovalidate: Self { .formnovalidate(true) }
  static func formtarget(_ v: Target) -> Self { .init(key: "formtarget", value: v.rawValue) }
  static func popovertarget(_ v: String) -> Self { .init(key: "popovertarget", value: v) }
  static func popovertargetaction(_ v: String) -> Self { .init(key: "popovertargetaction", value: v) }
}

// MARK: - Form Element Attributes

public extension HTMLAttribute where AttributeType == FormHTMLAttribute {
  static func acceptCharset(_ v: String) -> Self { .init(key: "accept-charset", value: v) }
  static func action(_ v: String) -> Self { .init(key: "action", value: v) }
  static func autocomplete(_ v: Autocomplete) -> Self { .init(key: "autocomplete", value: v.rawValue) }
  static func enctype(_ v: FormEnctype) -> Self { .init(key: "enctype", value: v.rawValue) }
  static func method(_ v: FormMethod) -> Self { .init(key: "method", value: v.rawValue) }
  static func novalidate(_ on: Bool) -> Self { .init(key: "novalidate", value: on ? "true" : "false") }
  static var novalidate: Self { .novalidate(true) }
  static func target(_ v: Target) -> Self { .init(key: "target", value: v.rawValue) }
}

// MARK: - Select Element Attributes

public extension HTMLAttribute where AttributeType == SelectHTMLAttribute {
  static func autocomplete(_ v: Autocomplete) -> Self { .init(key: "autocomplete", value: v.rawValue) }
  static func disabled(_ on: Bool) -> Self { .init(key: "disabled", value: on ? "true" : "false") }
  static var disabled: Self { .disabled(true) }
  static func form(_ v: String) -> Self { .init(key: "form", value: v) }
  static func multiple(_ on: Bool) -> Self { .init(key: "multiple", value: on ? "true" : "false") }
  static var multiple: Self { .multiple(true) }
  static func required(_ on: Bool) -> Self { .init(key: "required", value: on ? "true" : "false") }
  static var required: Self { .required(true) }
  static func size(_ v: some BinaryInteger) -> Self { .init(key: "size", value: "\(v)") }
}

// MARK: - Textarea Element Attributes

public extension HTMLAttribute where AttributeType == TextareaHTMLAttribute {
  static func autocomplete(_ v: Autocomplete) -> Self { .init(key: "autocomplete", value: v.rawValue) }
  static func cols(_ v: some BinaryInteger) -> Self { .init(key: "cols", value: "\(v)") }
  static func dirname(_ v: String) -> Self { .init(key: "dirname", value: v) }
  static func disabled(_ on: Bool) -> Self { .init(key: "disabled", value: on ? "true" : "false") }
  static var disabled: Self { .disabled(true) }
  static func form(_ v: String) -> Self { .init(key: "form", value: v) }
  static func maxlength(_ v: some BinaryInteger) -> Self { .init(key: "maxlength", value: "\(v)") }
  static func minlength(_ v: some BinaryInteger) -> Self { .init(key: "minlength", value: "\(v)") }
  static func readonly(_ on: Bool) -> Self { .init(key: "readonly", value: on ? "true" : "false") }
  static var readonly: Self { .readonly(true) }
  static func required(_ on: Bool) -> Self { .init(key: "required", value: on ? "true" : "false") }
  static var required: Self { .required(true) }
  static func rows(_ v: some BinaryInteger) -> Self { .init(key: "rows", value: "\(v)") }
  static func wrap(_ v: Wrap) -> Self { .init(key: "wrap", value: v.rawValue) }
}

// MARK: - Label Element Attributes

public extension HTMLAttribute where AttributeType == LabelHTMLAttribute {
  static func `for`(_ v: String) -> Self { .init(key: "for", value: v) }
}

// MARK: - Image Element Attributes

public extension HTMLAttribute where AttributeType == ImgHTMLAttribute {
  static func crossorigin(_ v: CrossOrigin) -> Self { .init(key: "crossorigin", value: v.rawValue) }
  static func decoding(_ v: Decoding) -> Self { .init(key: "decoding", value: v.rawValue) }
  static func fetchpriority(_ v: FetchPriority) -> Self { .init(key: "fetchpriority", value: v.rawValue) }
  static func ismap(_ on: Bool) -> Self { .init(key: "ismap", value: on ? "true" : "false") }
  static var ismap: Self { .ismap(true) }
  static func loading(_ v: Loading) -> Self { .init(key: "loading", value: v.rawValue) }
  static func referrerpolicy(_ v: ReferrerPolicy) -> Self { .init(key: "referrerpolicy", value: v.rawValue) }
  static func sizes(_ v: String) -> Self { .init(key: "sizes", value: v) }
  static func srcset(_ v: String) -> Self { .init(key: "srcset", value: v) }
  static func usemap(_ v: String) -> Self { .init(key: "usemap", value: v) }
}

// MARK: - Link Element Attributes

public extension HTMLAttribute where AttributeType == LinkHTMLAttribute {
  static func `as`(_ v: String) -> Self { .init(key: "as", value: v) }
  static func crossorigin(_ v: CrossOrigin) -> Self { .init(key: "crossorigin", value: v.rawValue) }
  static func fetchpriority(_ v: FetchPriority) -> Self { .init(key: "fetchpriority", value: v.rawValue) }
  static func hreflang(_ v: String) -> Self { .init(key: "hreflang", value: v) }
  static func imagesizes(_ v: String) -> Self { .init(key: "imagesizes", value: v) }
  static func imagesrcset(_ v: String) -> Self { .init(key: "imagesrcset", value: v) }
  static func integrity(_ v: String) -> Self { .init(key: "integrity", value: v) }
  static func media(_ v: String) -> Self { .init(key: "media", value: v) }
  static func ping(_ urls: [String]) -> Self { .init(key: "ping", value: urls.joined(separator: " ")) }
  static func referrerpolicy(_ v: ReferrerPolicy) -> Self { .init(key: "referrerpolicy", value: v.rawValue) }
  static func sizes(_ v: String) -> Self { .init(key: "sizes", value: v) }
  static func type(_ v: String) -> Self { .init(key: "type", value: v) }
  static func blocking(_ v: String) -> Self { .init(key: "blocking", value: v) }
  static func disabled(_ on: Bool) -> Self { .init(key: "disabled", value: on ? "true" : "false") }
  static var disabled: Self { .disabled(true) }
}

// MARK: - Media Element Attributes (Audio/Video)

public protocol MediaAttribute {}
extension VideoHTMLAttribute: MediaAttribute {}
extension AudioHTMLAttribute: MediaAttribute {}

public extension HTMLAttribute where AttributeType: MediaAttribute {
  static func autoplay(_ on: Bool) -> Self { .init(key: "autoplay", value: on ? "true" : "false") }
  static var autoplay: Self { .autoplay(true) }
  static func controls(_ on: Bool) -> Self { .init(key: "controls", value: on ? "true" : "false") }
  static var controls: Self { .controls(true) }
  static func controlslist(_ v: String) -> Self { .init(key: "controlslist", value: v) }
  static func crossorigin(_ v: CrossOrigin) -> Self { .init(key: "crossorigin", value: v.rawValue) }
  static func disablepictureinpicture(_ on: Bool) -> Self { .init(key: "disablepictureinpicture", value: on ? "true" : "false") }
  static var disablepictureinpicture: Self { .disablepictureinpicture(true) }
  static func disableremoteplayback(_ on: Bool) -> Self { .init(key: "disableremoteplayback", value: on ? "true" : "false") }
  static var disableremoteplayback: Self { .disableremoteplayback(true) }
  static func loop(_ on: Bool) -> Self { .init(key: "loop", value: on ? "true" : "false") }
  static var loop: Self { .loop(true) }
  static func muted(_ on: Bool) -> Self { .init(key: "muted", value: on ? "true" : "false") }
  static var muted: Self { .muted(true) }
  static func playsinline(_ on: Bool) -> Self { .init(key: "playsinline", value: on ? "true" : "false") }
  static var playsinline: Self { .playsinline(true) }
  static func poster(_ v: String) -> Self { .init(key: "poster", value: v) }
  static func preload(_ v: Preload) -> Self { .init(key: "preload", value: v.rawValue) }
}

// MARK: - Table Cell Attributes (td/th)

public extension HTMLAttribute where AttributeType == TableHTMLAttribute {
  static func colspan(_ v: some BinaryInteger) -> Self { .init(key: "colspan", value: "\(v)") }
  static func rowspan(_ v: some BinaryInteger) -> Self { .init(key: "rowspan", value: "\(v)") }
  static func headers(_ ids: [String]) -> Self { .init(key: "headers", value: ids.joined(separator: " ")) }
  static func scope(_ v: Scope) -> Self { .init(key: "scope", value: v.rawValue) }
  static func abbr(_ v: String) -> Self { .init(key: "abbr", value: v) }
}

// MARK: - Ordered List Attributes

public extension HTMLAttribute where AttributeType == OlHTMLAttribute {
  static func reversed(_ on: Bool) -> Self { .init(key: "reversed", value: on ? "true" : "false") }
  static var reversed: Self { .reversed(true) }
  static func start(_ v: some BinaryInteger) -> Self { .init(key: "start", value: "\(v)") }
  static func type(_ v: String) -> Self { .init(key: "type", value: v) }
}

// MARK: - List Item Attributes

public extension HTMLAttribute where AttributeType == LiHTMLAttribute {
  static func value(_ v: some BinaryInteger) -> Self { .init(key: "value", value: "\(v)") }
}

// MARK: - Meter Element Attributes

public extension HTMLAttribute where AttributeType == MeterHTMLAttribute {
  static func min(_ v: some Numeric) -> Self { .init(key: "min", value: "\(v)") }
  static func max(_ v: some Numeric) -> Self { .init(key: "max", value: "\(v)") }
  static func low(_ v: some Numeric) -> Self { .init(key: "low", value: "\(v)") }
  static func high(_ v: some Numeric) -> Self { .init(key: "high", value: "\(v)") }
  static func optimum(_ v: some Numeric) -> Self { .init(key: "optimum", value: "\(v)") }
}

// MARK: - Script Element Attributes

public extension HTMLAttribute where AttributeType == ScriptHTMLAttribute {
  static func async(_ on: Bool) -> Self { .init(key: "async", value: on ? "true" : "false") }
  static var async: Self { .async(true) }
  static func blocking(_ v: String) -> Self { .init(key: "blocking", value: v) }
  static func crossorigin(_ v: CrossOrigin) -> Self { .init(key: "crossorigin", value: v.rawValue) }
  static func `defer`(_ on: Bool) -> Self { .init(key: "defer", value: on ? "true" : "false") }
  static var `defer`: Self { .defer(true) }
  static func fetchpriority(_ v: FetchPriority) -> Self { .init(key: "fetchpriority", value: v.rawValue) }
  static func integrity(_ v: String) -> Self { .init(key: "integrity", value: v) }
  static func nomodule(_ on: Bool) -> Self { .init(key: "nomodule", value: on ? "true" : "false") }
  static var nomodule: Self { .nomodule(true) }
  static func referrerpolicy(_ v: ReferrerPolicy) -> Self { .init(key: "referrerpolicy", value: v.rawValue) }
  static func type(_ v: String) -> Self { .init(key: "type", value: v) }
}

// MARK: - Iframe Element Attributes

public extension HTMLAttribute where AttributeType == IframeHTMLAttribute {
  static func allow(_ v: String) -> Self { .init(key: "allow", value: v) }
  static func allowfullscreen(_ on: Bool) -> Self { .init(key: "allowfullscreen", value: on ? "true" : "false") }
  static var allowfullscreen: Self { .allowfullscreen(true) }
  static func allowpaymentrequest(_ on: Bool) -> Self { .init(key: "allowpaymentrequest", value: on ? "true" : "false") }
  static var allowpaymentrequest: Self { .allowpaymentrequest(true) }
  static func csp(_ v: String) -> Self { .init(key: "csp", value: v) }
  static func loading(_ v: Loading) -> Self { .init(key: "loading", value: v.rawValue) }
  static func referrerpolicy(_ v: ReferrerPolicy) -> Self { .init(key: "referrerpolicy", value: v.rawValue) }
  static func sandbox(_ values: [Sandbox]) -> Self { .init(key: "sandbox", value: values.map(\.rawValue).joined(separator: " ")) }
  static var sandbox: Self { .init(key: "sandbox", value: "") }
  static func srcdoc(_ v: String) -> Self { .init(key: "srcdoc", value: v) }
}

// MARK: - Details Element Attributes

public extension HTMLAttribute where AttributeType == DetailsHTMLAttribute {
  static func open(_ on: Bool) -> Self { .init(key: "open", value: on ? "true" : "false") }
  static var open: Self { .open(true) }
}

// MARK: - Dialog Element Attributes

public extension HTMLAttribute where AttributeType == DialogHTMLAttribute {
  static func open(_ on: Bool) -> Self { .init(key: "open", value: on ? "true" : "false") }
  static var open: Self { .open(true) }
}

// MARK: - Canvas Element Attributes

public extension HTMLAttribute where AttributeType == CanvasHTMLAttribute {
  // Note: width and height are already in global attributes
}

// MARK: - Track Element Attributes

public extension HTMLAttribute where AttributeType == TrackHTMLAttribute {
  static func `default`(_ on: Bool) -> Self { .init(key: "default", value: on ? "true" : "false") }
  static var `default`: Self { .default(true) }
  static func kind(_ v: TrackKind) -> Self { .init(key: "kind", value: v.rawValue) }
  static func label(_ v: String) -> Self { .init(key: "label", value: v) }
  static func srclang(_ v: String) -> Self { .init(key: "srclang", value: v) }
}

// MARK: - Area Element Attributes

public extension HTMLAttribute where AttributeType == AreaHTMLAttribute {
  static func coords(_ v: String) -> Self { .init(key: "coords", value: v) }
  static func download(_ v: String) -> Self { .init(key: "download", value: v) }
  static func ping(_ urls: [String]) -> Self { .init(key: "ping", value: urls.joined(separator: " ")) }
  static func referrerpolicy(_ v: ReferrerPolicy) -> Self { .init(key: "referrerpolicy", value: v.rawValue) }
  static func shape(_ v: Shape) -> Self { .init(key: "shape", value: v.rawValue) }
}

// MARK: - Source Element Attributes

public extension HTMLAttribute where AttributeType == SourceHTMLAttribute {
  static func media(_ v: String) -> Self { .init(key: "media", value: v) }
  static func sizes(_ v: String) -> Self { .init(key: "sizes", value: v) }
  static func srcset(_ v: String) -> Self { .init(key: "srcset", value: v) }
  static func type(_ v: String) -> Self { .init(key: "type", value: v) }
}

// MARK: - Embed Element Attributes

public extension HTMLAttribute where AttributeType == EmbedHTMLAttribute {
  static func type(_ v: String) -> Self { .init(key: "type", value: v) }
}

// MARK: - Object Element Attributes

public extension HTMLAttribute where AttributeType == ObjectHTMLAttribute {
  static func data(_ v: String) -> Self { .init(key: "data", value: v) }
  static func form(_ v: String) -> Self { .init(key: "form", value: v) }
  static func type(_ v: String) -> Self { .init(key: "type", value: v) }
  static func usemap(_ v: String) -> Self { .init(key: "usemap", value: v) }
}

// MARK: - Option Element Attributes

public extension HTMLAttribute where AttributeType == OptionHTMLAttribute {
  static func disabled(_ on: Bool) -> Self { .init(key: "disabled", value: on ? "true" : "false") }
  static var disabled: Self { .disabled(true) }
  static func selected(_ on: Bool) -> Self { .init(key: "selected", value: on ? "true" : "false") }
  static var selected: Self { .selected(true) }
}

// MARK: - Optgroup Element Attributes

public extension HTMLAttribute where AttributeType == OptgroupHTMLAttribute {
  static func disabled(_ on: Bool) -> Self { .init(key: "disabled", value: on ? "true" : "false") }
  static var disabled: Self { .disabled(true) }
}

// MARK: - Fieldset Element Attributes

public extension HTMLAttribute where AttributeType == FieldsetHTMLAttribute {
  static func disabled(_ on: Bool) -> Self { .init(key: "disabled", value: on ? "true" : "false") }
  static var disabled: Self { .disabled(true) }
  static func form(_ v: String) -> Self { .init(key: "form", value: v) }
}

// MARK: - Output Element Attributes

public extension HTMLAttribute where AttributeType == OutputHTMLAttribute {
  static func `for`(_ ids: [String]) -> Self { .init(key: "for", value: ids.joined(separator: " ")) }
  static func form(_ v: String) -> Self { .init(key: "form", value: v) }
}
