import CSkia

public typealias SKFontMetrics = sk_fontmetrics_t

public class SKFont {
  let pointer: OpaquePointer
  public init() {
    self.pointer = sk_font_new()
  }

  public init(typeface: SKTypeface, size: Float, scaleX: Float = 1.0, skewX: Float = 0.0) {
    self.pointer = sk_font_new_with_values(typeface.pointer, size, scaleX, skewX)
  }

  public var forceAutoHinting: Bool {
    get { sk_font_is_force_auto_hinting(pointer) }
    set { sk_font_set_force_auto_hinting(pointer, newValue) }
  }

  public var embeddedBitmaps: Bool {
    get { sk_font_is_embedded_bitmaps(pointer) }
    set { sk_font_set_embedded_bitmaps(pointer, newValue) }
  }

  public var subpixel: Bool {
    get { sk_font_is_subpixel(pointer) }
    set { sk_font_set_subpixel(pointer, newValue) }
  }

  public var linearMetrics: Bool {
    get { sk_font_is_linear_metrics(pointer) }
    set { sk_font_set_linear_metrics(pointer, newValue) }
  }

  public var embolden: Bool {
    get { sk_font_is_embolden(pointer) }
    set { sk_font_set_embolden(pointer, newValue) }
  }

  public var baselineSnap: Bool {
    get { sk_font_is_baseline_snap(pointer) }
    set { sk_font_set_baseline_snap(pointer, newValue) }
  }

  public var edging: sk_font_edging_t {
    get { sk_font_get_edging(pointer) }
    set { sk_font_set_edging(pointer, newValue) }
  }

  public var hinting: sk_font_hinting_t {
    get { sk_font_get_hinting(pointer) }
    set { sk_font_set_hinting(pointer, newValue) }
  }

  // var typeface: SKTypeface {
  //   get { SKTypeface(pointer: sk_font_get_typeface(pointer)) }
  //   set { sk_font_set_typeface(pointer, newValue.pointer) }
  // }

  public var scaleX: Float {
    get { sk_font_get_scale_x(pointer) }
    set { sk_font_set_scale_x(pointer, newValue) }
  }

  public var skewX: Float {
    get { sk_font_get_skew_x(pointer) }
    set { sk_font_set_skew_x(pointer, newValue) }
  }

  public var metrics: SKFontMetrics {
    var metrics = sk_fontmetrics_t()
    sk_font_get_metrics(pointer, &metrics)
    return metrics
  }

  public func getPos(glyphs: [UInt16], origin: SKPoint) -> [SKPoint] {
    var pos = [SKPoint](repeating: SKPoint(), count: glyphs.count)
    var origin = origin
    sk_font_get_pos(pointer, glyphs, Int32(glyphs.count), &pos, &origin)
    return pos
  }

  public func getXPos(glyphs: [UInt16], origin: Float) -> [Float] {
    var xpos = [Float](repeating: 0, count: glyphs.count)
    sk_font_get_xpos(pointer, glyphs, Int32(glyphs.count), &xpos, origin)
    return xpos
  }

  public var size: Float {
    get { sk_font_get_size(pointer) }
    set { sk_font_set_size(pointer, newValue) }
  }

  deinit {
    sk_font_delete(pointer)
  }
}
