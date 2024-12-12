import CSkia

public class SKFontStyleSet {
  var pointer: OpaquePointer

  init(pointer: OpaquePointer) {
    self.pointer = pointer
  }
  init() {
    self.pointer = sk_fontstyleset_create_empty()
  }

  func unref() {
    sk_fontstyleset_unref(self.pointer)
  }

  func getCount() -> Int {
    return Int(sk_fontstyleset_get_count(self.pointer))
  }

  func getStyle(index: Int) -> (SKFontStyle, String) {
    let fs = sk_fontstyle_new(0, 0, UPRIGHT_SK_FONT_STYLE_SLANT)!
    let styleName = sk_string_new_empty()!
    sk_fontstyleset_get_style(self.pointer, Int32(index), fs, styleName)
    return (SKFontStyle(pointer: fs), String(cString: sk_string_get_c_str(styleName)))
  }

  func createTypeface(index: Int) -> SKTypeface {
    let typeface = sk_fontstyleset_create_typeface(self.pointer, Int32(index))
    return SKTypeface(pointer: typeface!)
  }

  func matchStyle(style: SKFontStyle) -> SKTypeface {
    let typeface = sk_fontstyleset_match_style(self.pointer, style.pointer)
    return SKTypeface(pointer: typeface!)
  }
}
