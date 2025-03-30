import CSkia

public struct SKCanvas {
  let pointer: OpaquePointer
  public init(_ pointer: OpaquePointer) {
    self.pointer = pointer
  }

  public func save() {
    sk_canvas_save(pointer)
  }

  public func restore() {
    sk_canvas_restore(pointer)
  }

  public func resetMatrix() {
    sk_canvas_reset_matrix(pointer)
  }

  public func scale(x: Float, y: Float) {
    sk_canvas_scale(pointer, x, y)
  }

  public func translate(x: Float, y: Float) {
    sk_canvas_translate(pointer, x, y)
  }

  public func clear(color: SKColor) {
    sk_canvas_clear(pointer, color)
  }

  public func flushAndSubmit() {
    let recording_context = sk_get_recording_context(pointer)
    let ctx = gr_recording_context_get_direct_context(recording_context)
    gr_direct_context_flush_and_submit(ctx, true)
  }

  public func clip(
    path: SKPath, operation: sk_clipop_t = INTERSECT_SK_CLIPOP, antialias: Bool = true
  ) {
    sk_canvas_clip_path_with_operation(pointer, path.pointer, operation, antialias)
  }

  public func clip(rrect: SKRRect) {
    sk_canvas_clip_rrect_with_operation(pointer, rrect, INTERSECT_SK_CLIPOP, true)
  }

  public func draw(path: SKPath, paint: SKPaint) {
    sk_canvas_draw_path(pointer, path.pointer, paint.pointer)
  }

  public func draw(rrect: SKRRect, paint: SKPaint) {
    sk_canvas_draw_rrect(pointer, rrect, paint.pointer)
  }

  public func draw(rect: SKRect, paint: SKPaint) {
    var mutableRect = rect
    sk_canvas_draw_rect(pointer, &mutableRect, paint.pointer)
  }

  public func draw(circle: SKPoint, radius: Float, paint: SKPaint) {
    sk_canvas_draw_circle(pointer, circle.x, circle.y, radius, paint.pointer)
  }

  public func draw(simpleText: String, x: Float, y: Float, font: SKFont?, paint: SKPaint) {
    sk_canvas_draw_simple_text(
      pointer, simpleText, simpleText.utf8.count, UTF8_SK_TEXT_ENCODING, x, y, font?.pointer,
      paint.pointer)
  }

  public func draw(paragraph: SKParagraph, x: Float, y: Float) {
    paragraph.paint(canvas: self, x: x, y: y)
  }

  // func draw(image: SKImage, paint: SKPaint, matrix: SKMatrix) {
  //   var mutableMatrix = matrix
  //   sk_canvas_draw_image(self, image, 0, 0, &mutableMatrix, paint)
  // }

  public func draw(
    shadow: SKRRect, paint: SKPaint, blur: Float, offsetX: Float = 0, offsetY: Float = 0,
    spread: Float = 0
  ) {
    let maskFilter = paint.getMaskFilter()
    defer { paint.setMaskFilter(maskFilter) }

    let rrect = shadow.outset(dx: spread, dy: spread).offset(dx: offsetX, dy: offsetY)
    paint.setMaskFilter(makeMaskFilter(blur: NORMAL_SK_BLUR_STYLE, sigma: blur))
    draw(rrect: rrect, paint: paint)
  }

  public func draw(
    innerShadow: SKRRect, color: SKColor, blur: Float, offsetX: Float = 0, offsetY: Float = 0,
    spread: Float = 0
  ) {
    let rrect = innerShadow.offset(dx: offsetX, dy: offsetY)
    let paint = SKPaint()
    paint.setColor(color)
    paint.setStyle(.stroke)
    paint.setStrokeWidth(spread)
    paint.setAntiAlias(true)
    paint.setMaskFilter(makeMaskFilter(blur: NORMAL_SK_BLUR_STYLE, sigma: blur))
    save()
    clip(rrect: innerShadow)
    draw(rrect: rrect, paint: paint)
    restore()
  }
}
