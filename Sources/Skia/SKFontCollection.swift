import CSkia

public class SKFontCollection {
  var pointer: OpaquePointer

  public init() {
    self.pointer = sk_font_collection_new()
  }

  deinit {
    sk_font_collection_unref(self.pointer)
  }

  public func setDefaultFontManager(_ fontMgr: SKFontMgr) {
    sk_font_collection_set_default_font_manager(self.pointer, fontMgr.pointer)
  }
}
