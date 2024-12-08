import Skia

class DirtyArea {
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

  func isIntersect(view: View) -> Bool {
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

  func clip(canvas: SKCanvas) {
    canvas.clip(path: getDirtyPath())
  }

  func debugDraw(canvas: SKCanvas, paint: SKPaint) {
    canvas.draw(path: getDirtyPath(), paint: paint)
  }
}
