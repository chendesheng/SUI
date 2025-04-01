import Skia

public class DirtyArea {
  private var rects: [SKRect] = []

  func addRect(rect: SKRect?) {
    guard let rect = rect, !rect.isEmpty else {
      return
    }
    rects.append(rect)
  }

  var isEmpty: Bool {
    return rects.isEmpty
  }

  func isIntersect(_ view: View) -> Bool {
    let bounds = view.getBounds()!
    return rects.contains { dirtyRect in
      dirtyRect.isIntersect(bounds)
    }
  }

  private func getDirtyPath() -> SKPath {
    let path = SKPath()
    for rect in rects {
      path.add(rect: rect)
    }
    return path
  }

  func clip(_ canvas: SKCanvas) {
    canvas.clip(path: getDirtyPath())
  }

  func debugDraw(canvas: SKCanvas, paint: SKPaint) {
    canvas.draw(path: getDirtyPath(), paint: paint)
  }
}

class NoDirtyArea: DirtyArea {
  override func isIntersect(_ view: View) -> Bool {
    return true
  }

  override func clip(_ canvas: SKCanvas) {
    // do nothing
  }

  override func debugDraw(canvas: SKCanvas, paint: SKPaint) {
    // do nothing
  }
}
