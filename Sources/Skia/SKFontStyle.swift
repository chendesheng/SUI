import CSkia

public enum SKFontStyleSlant: UInt32 {
  case upright = 0
  case italic = 1
  case oblique = 2
}

public enum SKFontStyleWidth: UInt32 {
  case ultraCondensed = 0
  case extraCondensed = 1
  case condensed = 2
  case semiCondensed = 3
  case normal = 4
  case semiExpanded = 5
  case expanded = 6
  case extraExpanded = 7
  case ultraExpanded = 8
}

public enum SKFontStyleWeight: UInt32 {
  case thin = 100
  case extraLight = 200
  case light = 300
  case normal = 400
  case medium = 500
  case semiBold = 600
  case bold = 700
  case extraBold = 800
  case black = 900
}

public class SKFontStyle {
  let pointer: OpaquePointer

  public init(pointer: OpaquePointer) {
    self.pointer = pointer
  }

  public init(weight: SKFontStyleWeight, width: SKFontStyleWidth, slant: SKFontStyleSlant) {
    self.pointer = sk_fontstyle_new(
      Int32(weight.rawValue), Int32(width.rawValue), sk_font_style_slant_t(rawValue: slant.rawValue)
    )
  }

  deinit {
    sk_fontstyle_delete(pointer)
  }

  public var width: SKFontStyleWidth {
    SKFontStyleWidth(rawValue: UInt32(sk_fontstyle_get_width(pointer)))!
  }
  public var weight: SKFontStyleWeight {
    SKFontStyleWeight(rawValue: UInt32(sk_fontstyle_get_weight(pointer)))!
  }
  public var slant: SKFontStyleSlant {
    SKFontStyleSlant(rawValue: sk_fontstyle_get_slant(pointer).rawValue)!
  }

  public static var normal: SKFontStyle {
    SKFontStyle(weight: .normal, width: .normal, slant: .upright)
  }

  public static var italic: SKFontStyle {
    SKFontStyle(weight: .normal, width: .normal, slant: .italic)
  }

  public static var bold: SKFontStyle {
    SKFontStyle(weight: .bold, width: .normal, slant: .upright)
  }

  public static var boldItalic: SKFontStyle {
    SKFontStyle(weight: .bold, width: .normal, slant: .italic)
  }
}
