import Skia
import Yoga

public class View: EventEmitter {
  internal init(children: [View] = []) {
    self.children = children
    self.node = makeYGNode()
  }

  internal var children: [View] = []
  private weak var parent: View?
  internal let node: YGNode

  deinit {
    node.free()
  }

  public func appendChild(_ child: View) {
    children.append(child)
    child.parent = self
    node.insertChild(child.node, at: children.count - 1)
  }

  private func findAncestor<T: View>() -> T? {
    var ancestor: View? = parent
    while ancestor != nil {
      if let ancestor = ancestor as? T {
        return ancestor
      }
      ancestor = ancestor?.parent
    }
    return nil
  }

  var window: Window? {
    return findAncestor()
  }

  public var nodeRect: SKRect {
    return SKRect.make(width: nodeWidth, height: nodeHeight)
  }

  public var nodeLeft: Float {
    return node.getComputedLeft()
  }

  public var nodeTop: Float {
    return node.getComputedTop()
  }

  public var nodeWidth: Float {
    get {
      return node.getComputedWidth()
    }
    set {
      node.setWidth(newValue)
    }
  }

  public var nodeHeight: Float {
    get {
      return node.getComputedHeight()
    }
    set {
      node.setHeight(newValue)
    }
  }

  public var borderRadius: Float? {
    return nil
  }

  public var nodeRectRounded: SKRRect {
    let radius = borderRadius ?? 0
    return nodeRect.rounded(x: radius, y: radius)
  }

  public func drawSelf(_ canvas: SKCanvas) {
  }

  public func draw(_ canvas: SKCanvas) {
    drawSelf(canvas)

    for child in children {
      canvas.save()
      defer { canvas.restore() }

      canvas.translate(x: child.nodeLeft, y: child.nodeTop)
      child.draw(canvas)
    }
  }

  public func hitTest(_ point: SKPoint) -> Bool {
    return nodeRect.contains(point)
  }

  public func getBounds() -> SKRect? {
    return nil
  }

  public func getAbsolutePos() -> SKPoint {
    return SKPoint(x: nodeLeft, y: nodeTop)
  }
}
