import CSkia

public typealias SKParagraphPlaceholderStyle = sk_paragraph_placeholder_style_t

public class SKParagraphBuilder {
  var pointer: OpaquePointer

  public init(paragraphStyle: SKParagraphStyle, fontCollection: SKFontCollection) {
    self.pointer = sk_paragraph_builder_new(
      paragraphStyle.pointer, fontCollection.pointer)
  }

  deinit {
    sk_paragraph_builder_delete(self.pointer)
  }

  public func add(text: String) {
    sk_paragraph_builder_add_text(self.pointer, text, text.count)
  }

  public func add(placeholder: SKParagraphPlaceholderStyle) {
    sk_paragraph_builder_add_placeholder(self.pointer, placeholder)
  }

  public func build() -> SKParagraph {
    let paragraph = sk_paragraph_builder_build(self.pointer)
    return SKParagraph(pointer: paragraph!)
  }

  public func reset() {
    sk_paragraph_builder_reset(self.pointer)
  }

  public func push(style: SKTextStyle) {
    sk_paragraph_builder_push_style(self.pointer, style.pointer)
  }

  public func pop() {
    sk_paragraph_builder_pop(self.pointer)
  }

  public func peekStyle() -> SKTextStyle {
    let style = sk_paragraph_builder_peek_style(self.pointer)
    return SKTextStyle(pointer: style!)
  }

  public func getParagraphStyle() -> SKParagraphStyle {
    return SKParagraphStyle(sk_paragraph_builder_get_paragraph_style(self.pointer))
  }

  public func getText() -> String {
    let text = sk_paragraph_builder_get_text(self.pointer)
    return String(cString: text.data)
  }
}
