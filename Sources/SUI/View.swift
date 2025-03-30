import Skia
import Yoga

public struct Layout {
  let left: Float
  let top: Float
  let width: Float
  let height: Float
}

public enum WalkContinue {
  case Stop
  case NextSibling
  case Next
  case Void
}

public class View: EventEmitter {
  let name: String? = nil
  let id: String? = nil

  internal init(children: [View] = []) {
    self.children = children
    self.node = makeYGNode()
  }

  internal var children: [View] = []
  private weak var parent: View?
  internal var node: YGNode
  public var interactive: Bool {
    return true
  }
  public var focusable: Bool {
    return false
  }
  public var notifySizeChanged: Bool {
    return false
  }
  public var notifyPositionChanged: Bool {
    return false
  }
  public var hidden: Bool {
    get {
      return node.hidden
    }
    set {
      node.hidden = newValue
    }
  }

  public var tooltip: String? {
    return nil
  }

  public var zIndex: Int? {
    return nil
  }

  public func refresh() {
    if !isMounted {
      return
    }

    if notifySizeChanged {
      node.markDirty()
    }
  }

  public var window: Window? {
    return findAncestor()
  }

  public var isMounted: Bool {
    return self.window != nil
  }

  public func getChildrenOrderByZIndex() -> [View] {
    let hasZIndex = children.filter { $0.zIndex != nil }
    if hasZIndex.isEmpty {
      return children
    }

    let noZIndex = children.filter { $0.zIndex == nil }
    let zIndex = hasZIndex.sorted { $0.zIndex! < $1.zIndex! }
    return noZIndex + zIndex
  }

  deinit {
    node.free()
  }

  public func appendChild(_ child: View) {
    children.append(child)
    child.parent = self
    node.insertChild(child.node, at: children.count - 1)
  }

  func insertChild(_ view: View, at index: Int?) {
    let i = index ?? children.count
    children.insert(view, at: i)
    node.insertChild(view.node, at: i)
    view.parent = self
    if isMounted {
      _ = walk { v in
        v.dispatchEvent(ViewEvent.DidMount(target: v))
        return .Void
      }
    }
  }
  func removeChildAt(_ index: Int, _ refresh: Bool = true) {
    guard index >= 0 && index < children.count else {
      return
    }

    let view = children[index]
    if refresh {
      view.refresh()
    }

    if isMounted {
      _ = view.walk { v in
        v.dispatchEvent(ViewEvent.WillUnmount(target: v))
        return .Void
      }
    }

    view.parent = nil
    node.removeChild(view.node)
    children.remove(at: index)
    view.layout = nil
    dispatchEvent(ViewEvent.ChildrenChanged(target: self, detail: ["removeAt": index]))
  }

  public func removeChild(_ view: View, _ refresh: Bool = true) {
    if let index = children.firstIndex(where: { $0 === view }) {
      removeChildAt(index, refresh)
    }
  }

  public func removeAllChildren(_ refresh: Bool = true) {
    if refresh {
      self.refresh()
    }

    if isMounted {
      _ = walk { v in
        v.dispatchEvent(ViewEvent.WillUnmount(target: v))
        return .Void
      }
    }

    for child in children {
      child.parent = nil
      self.node.removeChild(child.node)
    }

    self.children = []
    self.dispatchEvent(ViewEvent.ChildrenChanged(target: self, detail: ["removeAll": true]))
  }

  public var layout: Layout? = nil

  public func walk(_ callback: (View) -> WalkContinue, filter: ((View) -> Bool)? = nil) -> Bool {
    if let filter = filter {
      if !filter(self) {
        return false
      }
    }

    let result = callback(self)
    if result == .Stop {
      return true
    } else if result == .NextSibling {
      return false
    }

    for child in children {
      if child.walk(callback, filter: filter) {
        return true
      }
    }

    return false
  }

  public func walkAround(_ fn: (View, Bool) -> Void, filter: ((View) -> Bool)? = nil) {
    if let filter = filter {
      if !filter(self) {
        return
      }
    }

    fn(self, true)
    for child in children {
      child.walkAround(fn, filter: filter)
    }
    fn(self, false)
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

  public func findAncestorBy(_ callback: (View) -> Bool) -> View? {
    var ancestor: View? = parent
    while ancestor != nil {
      if callback(ancestor!) {
        return ancestor
      }
      ancestor = ancestor?.parent
    }
    return nil
  }

  public func findDescendant(_ pred: (View) -> Bool, _ includeSelf: Bool = false) -> View? {
    if includeSelf && pred(self) {
      return self
    }

    for child in children {
      if pred(child) { return child }

      if let result = child.findDescendant(pred, true) {
        return result
      }
    }

    return nil
  }

  public func findBy(name: String) -> View? {
    return findDescendant({ $0.name == name }, true)
  }

  public func findBy(id: String) -> View? {
    return findDescendant({ $0.id == id }, true)
  }

  public func findChild(_ pred: (View) -> Bool) -> View? {
    for child in children {
      if pred(child) { return child }
    }

    return nil
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

  public var nodePaddingLeft: Float {
    return node.getComputedLeft()
  }

  public var nodePaddingTop: Float {
    return node.getComputedTop()
  }

  public var nodePaddingRight: Float {
    return node.getComputedRight()
  }

  public var nodePaddingBottom: Float {
    return node.getComputedBottom()
  }

  public var borderRadius: Float? {
    return nil
  }

  public var nodeRectRounded: SKRRect {
    return nodeRect.toRRect(radius: borderRadius ?? 0)
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

  func drawChildren(_ canvas: SKCanvas) {
    let clip = node.getOverflow()
    if clip == 0 {
      canvas.save()
      defer { canvas.restore() }

      canvas.clip(rrect: nodeRectRounded)
    }

    for child in self.getChildrenOrderByZIndex() {
      self.drawChild(canvas, child)
    }
  }

  func drawChild(_ canvas: SKCanvas, _ child: View) {
    let x = child.nodeLeft
    let y = child.nodeTop
    canvas.translate(x: x, y: y)
    defer { canvas.translate(x: -x, y: -y) }

    child.draw(canvas)
  }

  var nodeInnerRect: SKRect {
    let paddingLeft = nodePaddingLeft
    let paddingTop = nodePaddingTop
    let paddingRight = nodePaddingRight
    let paddingBottom = nodePaddingBottom
    if paddingLeft == 0 && paddingTop == 0 && paddingRight == 0 && paddingBottom == 0 {
      return nodeRect
    }

    return makeRect(
      pos: SKPoint.make(paddingLeft, paddingTop),
      size: SKSize.make(
        nodeWidth - paddingLeft - paddingRight,
        nodeHeight - paddingTop - paddingBottom))
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

  public func isSelfOrAncestorOf(_ view: View) -> Bool {
    return self === view || isAncestorOf(view)
  }

  public func isAncestorOf(_ view: View) -> Bool {
    return findAncestorBy { $0 === view } != nil
  }
}
