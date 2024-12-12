import CSkia

public class SKPaint {
  let pointer: OpaquePointer

  public init() {
    self.pointer = sk_paint_new()
  }

  public init(pointer: OpaquePointer) {
    self.pointer = pointer
  }

  public convenience init(color: SKColor) {
    self.init()
    setColor(color)
  }

  public convenience init(antialias: Bool) {
    self.init()
    setAntiAlias(antialias)
  }

  public convenience init(style: SKPaintStyle) {
    self.init()
    setStyle(style)
  }

  deinit {
    sk_paint_delete(pointer)
  }

  public func setColor(_ color: SKColor) {
    sk_paint_set_color(pointer, color)
  }

  public func setShader(_ shader: SKShader?) {
    sk_paint_set_shader(pointer, shader?.pointer)
  }

  public func setMaskFilter(_ filter: SKMaskFilter?) {
    sk_paint_set_maskfilter(pointer, filter)
  }

  public func getMaskFilter() -> SKMaskFilter? {
    return sk_paint_get_maskfilter(pointer)
  }

  public func setAntiAlias(_ antialias: Bool) {
    sk_paint_set_antialias(pointer, antialias)
  }

  public var isAntiAlias: Bool {
    return sk_paint_is_antialias(pointer)
  }

  public func setStyle(_ style: SKPaintStyle) {
    sk_paint_set_style(pointer, sk_paint_style_t(style.rawValue))
  }

  public func setStrokeWidth(_ width: Float) {
    sk_paint_set_stroke_width(pointer, width)
  }
}
