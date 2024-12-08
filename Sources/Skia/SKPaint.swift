import CSkia

public class SKPaint {
  let pointer: OpaquePointer

  public init() {
    self.pointer = sk_paint_new()
  }

  public convenience init(color: SKColor) {
    self.init()
    setColor(color)
  }

  public convenience init(color: Colors) {
    self.init()
    setColor(color)
  }

  deinit {
    sk_paint_delete(pointer)
  }

  public func setColor(_ color: SKColor) {
    sk_paint_set_color(pointer, color)
  }

  public func setColor(_ color: Colors) {
    sk_paint_set_color(pointer, color.rawValue)
  }

  public func setMaskFilter(_ filter: SKMaskFilter) {
    sk_paint_set_maskfilter(pointer, filter)
  }

  public func getMaskFilter() -> SKMaskFilter? {
    return sk_paint_get_maskfilter(pointer)
  }

  public func setAntiAlias(_ antialias: Bool) {
    sk_paint_set_antialias(pointer, antialias)
  }
  public func setStyle(_ style: SKPaintStyle) {
    sk_paint_set_style(pointer, sk_paint_style_t(style.rawValue))
  }
}
