import CSkia

public class SKFontStyle {
  let pointer: OpaquePointer

  public init(pointer: OpaquePointer) {
    self.pointer = pointer
  }

  public init(weight: Int32, width: Int32, slant: sk_font_style_slant_t) {
    self.pointer = sk_fontstyle_new(weight, width, slant)
  }

  deinit {
    sk_fontstyle_delete(pointer)
  }

  public var width: Int32 { sk_fontstyle_get_width(pointer) }
  public var weight: Int32 { sk_fontstyle_get_weight(pointer) }
  public var slant: sk_font_style_slant_t { sk_fontstyle_get_slant(pointer) }
}
