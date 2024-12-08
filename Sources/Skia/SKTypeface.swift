import CSkia

public class SKTypeface {
  let pointer: OpaquePointer
  public init() {
    self.pointer = sk_typeface_create_default()
  }

  public init(file: String, index: Int32 = 0) {
    self.pointer = sk_typeface_create_from_file(file, index)
  }

  public var fontWidth: Int { Int(sk_typeface_get_font_width(pointer)) }
  public var fontWeight: Int { Int(sk_typeface_get_font_weight(pointer)) }
  public var fontStyle: SKFontStyle { SKFontStyle(pointer: sk_typeface_get_fontstyle(pointer)) }
  public var fontSlant: sk_font_style_slant_t { sk_typeface_get_font_slant(pointer) }
  public var isFixedPitch: Bool { sk_typeface_is_fixed_pitch(pointer) }
  public var countGlyphs: Int { Int(sk_typeface_count_glyphs(pointer)) }
  public var countTables: Int { Int(sk_typeface_count_tables(pointer)) }
  public func unicharsToGlyphs(unichars: [Int32]) -> [UInt16] {
    var glyphs = [UInt16](repeating: 0, count: unichars.count)
    sk_typeface_unichars_to_glyphs(pointer, unichars, Int32(unichars.count), &glyphs)
    return glyphs
  }
  public func unicharToGlyph(unichar: Int32) -> UInt16 {
    sk_typeface_unichar_to_glyph(pointer, unichar)
  }
  // public var familyName: String { sk_typeface_get_family_name(pointer) }

  deinit {
    sk_typeface_unref(pointer)
  }
}
