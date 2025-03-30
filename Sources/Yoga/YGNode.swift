import yoga

public typealias YGNode = YGNodeRef
public typealias Size = YGSize

public func makeYGNode() -> YGNode {
  return YGNodeNew()
}

extension YGNode {
  public func insertChild(_ child: YGNode, at index: Int) {
    YGNodeInsertChild(self, child, index)
  }

  public func free() {
    YGNodeFree(self)
  }

  public func calculateLayout(width: Float, height: Float) {
    YGNodeCalculateLayout(self, width, height, YGDirection.LTR)
  }

  public func calculateLayout(width: Int32, height: Int32) {
    YGNodeCalculateLayout(self, Float(width), Float(height), YGDirection.LTR)
  }

  public func getComputedWidth() -> Float {
    return YGNodeLayoutGetWidth(self)
  }

  public func getComputedHeight() -> Float {
    return YGNodeLayoutGetHeight(self)
  }

  public func getComputedLeft() -> Float {
    return YGNodeLayoutGetLeft(self)
  }

  public func getComputedTop() -> Float {
    return YGNodeLayoutGetTop(self)
  }

  public func getComputedRight() -> Float {
    return YGNodeLayoutGetRight(self)
  }

  public func getComputedBottom() -> Float {
    return YGNodeLayoutGetBottom(self)
  }

  public func setWidth(_ width: Float) {
    YGNodeStyleSetWidth(self, width)
  }

  public func setWidthAuto() {
    YGNodeStyleSetWidthAuto(self)
  }

  public func setHeight(_ height: Float) {
    YGNodeStyleSetHeight(self, height)
  }

  public func setPadding(_ edge: YGEdge, _ value: Float) {
    YGNodeStyleSetPadding(self, edge, value)
  }

  public func setHeightAuto() {
    YGNodeStyleSetHeightAuto(self)
  }

  public func setLeft(_ left: Float) {
    YGNodeStyleSetPosition(self, YGEdge.left, left)
  }

  public func setTop(_ top: Float) {
    YGNodeStyleSetPosition(self, YGEdge.top, top)
  }

  public func setFlexDirection(_ flexDirection: YGFlexDirection) {
    YGNodeStyleSetFlexDirection(self, flexDirection)
  }

  public func setAlignItems(_ alignItems: YGAlign) {
    YGNodeStyleSetAlignItems(self, alignItems)
  }

  public func setJustifyContent(_ justifyContent: YGJustify) {
    YGNodeStyleSetJustifyContent(self, justifyContent)
  }

  public func setFlexGrow(_ flexGrow: Float) {
    YGNodeStyleSetFlexGrow(self, flexGrow)
  }

  public func setFlexShrink(_ flexShrink: Float) {
    YGNodeStyleSetFlexShrink(self, flexShrink)
  }

  public func setMeasureFunc(_ measureFunc: @escaping YGMeasureFunc) {
    YGNodeSetMeasureFunc(self, measureFunc)
  }

  public func markDirty() {
    YGNodeMarkDirty(self)
  }

  public var hidden: Bool {
    get {
      return YGNodeStyleGetDisplay(self) == .none
    }
    set {
      YGNodeStyleSetDisplay(self, newValue ? .none : .flex)
    }
  }

  public func removeChild(_ child: YGNode) {
    YGNodeRemoveChild(self, child)
  }

  public func getOverflow() -> Int32 {
    return YGNodeStyleGetOverflow(self).rawValue
  }
}
