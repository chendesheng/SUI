import CSkia

public typealias SKTextAlign = sk_text_align_t

public class SKParagraphStyle {
  internal var pointer: OpaquePointer

  public init() {
    self.pointer = sk_paragraph_style_new()!
  }

  public init(_ pointer: OpaquePointer) {
    self.pointer = pointer
  }

  deinit {
    sk_paragraph_style_delete(self.pointer)
  }

  public var textStyle: SKTextStyle {
    get {
      let textStyle = sk_paragraph_style_get_text_style(self.pointer)!
      return SKTextStyle(pointer: textStyle)
    }

    set {
      sk_paragraph_style_set_text_style(self.pointer, newValue.pointer)
    }
  }

  public var textAlign: SKTextAlign {
    get {
      return sk_paragraph_style_get_text_align(self.pointer)
    }

    set {
      sk_paragraph_style_set_text_align(self.pointer, newValue)
    }
  }
}
