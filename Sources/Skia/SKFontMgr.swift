import CSkia

public class SKFontMgr {
  var pointer: OpaquePointer

  public init() {
    self.pointer = sk_fontmgr_create_default()
  }

  public func countFamilies() -> Int {
    return Int(sk_fontmgr_count_families(self.pointer))
  }

  public func getFamilyName(index: Int) -> String {
    let familyName = sk_string_new_empty()!
    sk_fontmgr_get_family_name(self.pointer, Int32(index), familyName)
    return String(cString: sk_string_get_c_str(familyName))
  }

  public func createStyleset(index: Int) -> SKFontStyleSet {
    let styleSet = sk_fontmgr_create_styleset(self.pointer, Int32(index))
    return SKFontStyleSet(pointer: styleSet!)
  }

  public func matchFamily(familyName: String) -> SKFontStyleSet {
    let styleSet = sk_fontmgr_match_family(self.pointer, familyName)
    return SKFontStyleSet(pointer: styleSet!)
  }
}
