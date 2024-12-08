import CSkia

public class SKPath {
  let pointer: OpaquePointer
  public init() {
    pointer = sk_path_new()
  }

  deinit {
    sk_path_delete(pointer)
  }

  convenience init(svg: String) {
    self.init()
    parse(svg: svg)
  }

  public func parse(svg: String) {
    sk_path_parse_svg_string(pointer, svg)
  }

  public func add(path: SKPath, mode: sk_path_add_mode_t) {
    sk_path_add_path(pointer, path.pointer, mode)
  }

  public func add(rect: SKRect, direction: sk_path_direction_t = CW_SK_PATH_DIRECTION) {
    var mutableRect = rect
    sk_path_add_rect(pointer, &mutableRect, direction)
  }

  public func moveTo(x: Float, y: Float) {
    sk_path_move_to(pointer, x, y)
  }

  public func rMoveTo(dx: Float, dy: Float) {
    sk_path_rmove_to(pointer, dx, dy)
  }

  public func lineTo(x: Float, y: Float) {
    sk_path_line_to(pointer, x, y)
  }

  public func rLineTo(dx: Float, dy: Float) {
    sk_path_rline_to(pointer, dx, dy)
  }

  public func arcTo(
    rx: Float, ry: Float, xAxisRotate: Float, largeArc: Bool, sweep: Bool, x: Float, y: Float
  ) {
    sk_path_arc_to(
      pointer, rx, ry, xAxisRotate, largeArc ? LARGE_SK_PATH_ARC_SIZE : SMALL_SK_PATH_ARC_SIZE,
      sweep ? CW_SK_PATH_DIRECTION : CCW_SK_PATH_DIRECTION, x, y)
  }

  public func rArcTo(
    rx: Float, ry: Float, xAxisRotate: Float, largeArc: Bool, sweep: Bool, x: Float, y: Float
  ) {
    sk_path_rarc_to(
      pointer, rx, ry, xAxisRotate, largeArc ? LARGE_SK_PATH_ARC_SIZE : SMALL_SK_PATH_ARC_SIZE,
      sweep ? CW_SK_PATH_DIRECTION : CCW_SK_PATH_DIRECTION, x, y)
  }

  public func cubicTo(x1: Float, y1: Float, x2: Float, y2: Float, x3: Float, y3: Float) {
    sk_path_cubic_to(pointer, x1, y1, x2, y2, x3, y3)
  }

  public func rCubicTo(dx1: Float, dy1: Float, dx2: Float, dy2: Float, dx3: Float, dy3: Float) {
    sk_path_rcubic_to(pointer, dx1, dy1, dx2, dy2, dx3, dy3)
  }

  public func quadTo(x1: Float, y1: Float, x2: Float, y2: Float) {
    sk_path_quad_to(pointer, x1, y1, x2, y2)
  }

  public func rQuadTo(dx1: Float, dy1: Float, dx2: Float, dy2: Float) {
    sk_path_rquad_to(pointer, dx1, dy1, dx2, dy2)
  }

  public func conicTo(x1: Float, y1: Float, x2: Float, y2: Float, weight: Float) {
    sk_path_conic_to(pointer, x1, y1, x2, y2, weight)
  }

  public func rConicTo(dx1: Float, dy1: Float, dx2: Float, dy2: Float, weight: Float) {
    sk_path_rconic_to(pointer, dx1, dy1, dx2, dy2, weight)
  }

  public func close() {
    sk_path_close(pointer)
  }

  public func reset() {
    sk_path_reset(pointer)
  }

  public func contains(pt: SKPoint) -> Bool {
    return sk_path_contains(pointer, pt.x, pt.y)
  }
}
