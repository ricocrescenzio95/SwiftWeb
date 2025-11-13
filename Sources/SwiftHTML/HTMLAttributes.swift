public enum Dir: String { case ltr, rtl, auto }
public enum ContentEditable: String { case `true`, `false`, plaintextOnly = "plaintext-only" }
public enum EnterKeyHint: String { case enter, done, go, next, previous, search, send }
public enum InputMode: String { case none, text, tel, url, email, numeric, decimal, search }
public enum Translate: String { case yes, no }

public struct HTMLAttribute<AttributeType> {
  public let key: String
  public let value: String?
  
  private init(key: String, value: String?) {
    self.key = key
    self.value = value
  }
  
  public static func rawHTML(key: String, value: String?) -> Self { .init(key: key, value: value) }
}

public extension HTMLAttribute {
  // Factories (typed)
  static func accesskey(_ v: String) -> Self { .init(key: "accesskey", value: v) }
  static func autocapitalize(_ v: String) -> Self { .init(key: "autocapitalize", value: v) }
  static func autofocus(_ on: Bool = true) -> Self { .init(key: "autofocus", value: on ? "" : nil) }
  static func `class`(_ classes: [String]) -> Self { .init(key: "class", value: classes.joined(separator: " ")) }
  static func `class`(_ class: String...) -> Self { .init(key: "class", value: `class`.joined(separator: " ")) }
  static func contenteditable(_ mode: ContentEditable) -> Self { .init(key: "contenteditable", value: mode.rawValue) }
  static func dir(_ v: Dir) -> Self { .init(key: "dir", value: v.rawValue) }
  static func draggable(_ on: Bool) -> Self { .init(key: "draggable", value: on ? "true" : "false") }
  static func enterkeyhint(_ v: EnterKeyHint) -> Self { .init(key: "enterkeyhint", value: v.rawValue) }
  static func hidden(_ on: Bool = true) -> Self { .init(key: "hidden", value: on ? "" : nil) }
  static func id(_ v: String) -> Self { .init(key: "id", value: v) }
  static func inert(_ on: Bool = true) -> Self { .init(key: "inert", value: on ? "" : nil) }
  static func inputmode(_ v: InputMode) -> Self { .init(key: "inputmode", value: v.rawValue) }
  static func is_(_ v: String) -> Self { .init(key: "is", value: v) }
  static func itemid(_ v: String) -> Self { .init(key: "itemid", value: v) }
  static func itemprop(_ tokens: [String]) -> Self { .init(key: "itemprop", value: tokens.joined(separator: " ")) }
  static func itemref(_ ids: [String]) -> Self { .init(key: "itemref", value: ids.joined(separator: " ")) }
  static func itemscope(_ on: Bool = true) -> Self { .init(key: "itemscope", value: on ? "" : nil) }
  static func itemtype(_ urls: [String]) -> Self { .init(key: "itemtype", value: urls.joined(separator: " ")) }
  static func lang(_ v: String) -> Self { .init(key: "lang", value: v) }
  static func nonce(_ v: String) -> Self { .init(key: "nonce", value: v) }
  static func part(_ tokens: [String]) -> Self { .init(key: "part", value: tokens.joined(separator: " ")) }
  static func popover(_ on: Bool = true) -> Self { .init(key: "popover", value: on ? "" : nil) }
  static func slot(_ v: String) -> Self { .init(key: "slot", value: v) }
  static func spellcheck(_ on: Bool) -> Self { .init(key: "spellcheck", value: on ? "true" : "false") }
  static func style(_ css: CSS.Property...) -> Self { .init(key: "style", value: CSS.Body(css).cssValue) }
  static func style(_ css: [CSS.Property]) -> Self { .init(key: "style", value: CSS.Body(css).cssValue) }
  static func tabindex(_ i: Int) -> Self { .init(key: "tabindex", value: String(i)) }
  static func title(_ v: String) -> Self { .init(key: "title", value: v) }
  static func translate(_ v: Translate) -> Self { .init(key: "translate", value: v.rawValue) }
  static func role(_ v: String) -> Self { .init(key: "role", value: v) }
  static func href(_ v: String) -> Self { .init(key: "href", value: v) }
  
  // Flexible
  static func aria(_ name: String, _ v: String) -> Self { .init(key: "aria-\(name)", value: v) }
  static func data(_ name: String, _ v: String) -> Self { .init(key: "data-\(name)", value: v) }
}

public extension HTMLAttribute {
  static func charset(_ v: String) -> Self { .init(key: "charset", value: v) }
  static func name(_ v: String) -> Self { .init(key: "name", value: v) }
  static func content(_ v: String) -> Self { .init(key: "content", value: v) }
}
