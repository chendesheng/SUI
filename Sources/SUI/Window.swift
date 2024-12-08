import GLFW
import Skia

public class Window: View, GLWindowDelegate {
  public private(set) var glWindow: GLWindow?
  private var ctx: GRContext?
  private var surface: SKSurface?
  var canvas: SKCanvas? {
    return surface?.getCanvas()
  }

  var title: String {
    get {
      return glWindow?.getWindowTitle() ?? ""
    }
    set {
      glWindow?.setWindowTitle(newValue)
    }
  }

  public init?(width: Int32, height: Int32, title: String) {
    super.init()

    node.setFlexDirection(.column)
    node.setAlignItems(.center)
    node.setJustifyContent(.center)

    guard let glWindow = GLWindow.createWindow(width: width, height: height, title: title) else {
      return nil
    }

    glWindow.setUserPointer(self)
    glWindow.installEvents()
    glWindow.makeContextCurrent()

    self.glWindow = glWindow
    guard let ctx = GRContext.createContext() else {
      return nil
    }
    self.ctx = ctx

    let (width, height) = glWindow.getFramebufferSize()
    guard let surface = ctx.createSurface(width: width, height: height) else {
      return nil
    }
    self.surface = surface
  }

  public func handleClose() {
    close()
  }

  public func handleKey(key: Key, action: GLFWAction) {
    if action == .press {
      dispatchEvent(.Keypress(target: self, data: key))
    }
  }

  public func handleResize(width: Int32, height: Int32) {
    dispatchEvent(.Resize(target: self, data: SKSize.make(width, height)))
  }

  public func handleFramebufferResize(width: Int32, height: Int32) {
    surface = ctx?.createSurface(width: width, height: height)
    render()
  }

  public func handleMouseButton(button: MouseButton, action: GLFWAction, position: (Double, Double))
  {
    let (x, y) = position
    let point = SKPoint.make(Float(x), Float(y))
    if let hitted = hitTest(point) {
      if action == .press {
        hitted.dispatchEvent(
          .MouseDown(
            target: self,
            data: MouseEventData(button: button, position: point)))
      } else if action == .release {
        hitted.dispatchEvent(
          .MouseUp(
            target: hitted,
            data: MouseEventData(button: button, position: point)))
        hitted.dispatchEvent(
          .Click(target: hitted, data: MouseEventData(button: button, position: point)))
      }
    }
  }

  public func show() {
    glWindow?.show()
  }

  public func hide() {
    glWindow?.hide()
  }

  public func minimize() {
    glWindow?.iconify()
  }

  public func restore() {
    glWindow?.restore()
  }

  public func close() {
    guard var glWindow = glWindow else {
      return
    }

    glWindow.windowShouldClose = true
    dispatchEvent(.WindowClose(target: self))
  }

  public var isMinimized: Bool {
    return glWindow?.isMinimized ?? false
  }

  public var isClosing: Bool {
    return glWindow?.windowShouldClose ?? false
  }

  public var isClosed: Bool {
    return glWindow == nil
  }

  func destroy() {
    if let win = glWindow {
      glWindow = nil
      surface?.unrefSurface()
      ctx?.freeGpuResources()
      win.destroyWindow()
    }
  }

  private func hitTest(_ point: SKPoint) -> View? {
    func doHitTest(view: View, point: SKPoint) -> View? {
      let hitted = view.hitTest(point)
      for child in view.children {
        let relativePoint = SKPoint.make(point.x - child.nodeLeft, point.y - child.nodeTop)
        if let hitView = doHitTest(view: child, point: relativePoint) {
          return hitView
        }
      }
      if hitted {
        return view
      }
      return nil
    }

    return doHitTest(view: self, point: point)
  }

  func render() {
    guard let glWindow = self.glWindow else {
      return
    }

    guard let canvas = self.canvas else {
      return
    }

    let (width, height) = glWindow.getWindowSize()
    node.calculateLayout(width: width, height: height)

    glWindow.makeContextCurrent()

    canvas.resetMatrix()
    let (scaleX, scaleY) = glWindow.getContentScale()
    canvas.scale(x: scaleX, y: scaleY)

    canvas.clear(color: 0xffff_ffff)
    draw(canvas)

    canvas.flushAndSubmit()
    glWindow.swapBuffers()
  }
}
