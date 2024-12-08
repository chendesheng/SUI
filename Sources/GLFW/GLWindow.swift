import CGLFW3

public enum Key: Int32 {
  case Escape = 256
  case LeftControl = 341
}

public enum MouseButton: Int32 {
  case Left = 0
  case Right = 1
  case Middle = 2
}

extension OpaquePointer {
  public func getUserPointer() -> UnsafeMutableRawPointer {
    return glfwGetWindowUserPointer(self)
  }

  public func setUserPointer(_ pointer: AnyObject) {
    glfwSetWindowUserPointer(self, Unmanaged.passUnretained(pointer).toOpaque())
  }
}

public struct GLWindow {
  private let pointer: OpaquePointer
  init(_ pointer: OpaquePointer) {
    self.pointer = pointer
  }

  public static func createWindow(width: Int32, height: Int32, title: String) -> GLWindow? {
    let window = glfwCreateWindow(width, height, title, nil, nil)
    guard let window = window else {
      let error = glfwGetError(nil)
      print("Failed to create GLFW window: \(error)")
      return nil
    }
    return GLWindow(window)
  }

  var delegate: GLWindowDelegate {
    return Unmanaged<AnyObject>.fromOpaque(glfwGetWindowUserPointer(pointer))
      .takeUnretainedValue() as! GLWindowDelegate
  }

  public func setUserPointer(_ win: GLWindowDelegate) {
    pointer.setUserPointer(win)
  }

  public func installEvents() {
    glfwSetWindowSizeCallback(pointer) { window, width, height in
      guard let window = window else {
        return
      }
      let win = GLWindow(window).delegate
      win.handleResize(width: width, height: height)
    }

    glfwSetKeyCallback(pointer) { window, key, scancode, action, mods in
      guard let window = window else {
        return
      }
      let win = GLWindow(window).delegate
      if let key = Key(rawValue: key) {
        win.handleKey(key: key, action: GLFWAction(rawValue: action)!)
      }
    }

    glfwSetMouseButtonCallback(pointer) { window, button, action, mods in
      guard let window = window else {
        return
      }
      let glWin = GLWindow(window)
      let position = glWin.getCursorPosition()
      glWin.delegate.handleMouseButton(
        button: MouseButton(rawValue: button)!,
        action: GLFWAction(rawValue: action)!,
        position: position)
    }

    glfwSetWindowCloseCallback(pointer) { window in
      guard let window = window else {
        return
      }
      let win = GLWindow(window).delegate
      win.handleClose()
    }

    glfwSetFramebufferSizeCallback(pointer) { window, width, height in
      guard let window = window else {
        return
      }
      let win = GLWindow(window).delegate
      win.handleFramebufferResize(width: width, height: height)
    }
  }

  public func getFramebufferSize() -> (Int32, Int32) {
    var width: Int32 = 0
    var height: Int32 = 0
    glfwGetFramebufferSize(pointer, &width, &height)
    return (width, height)
  }

  public func getWindowSize() -> (Int32, Int32) {
    var width: Int32 = 0
    var height: Int32 = 0
    glfwGetWindowSize(pointer, &width, &height)
    return (width, height)
  }

  public func getContentScale() -> (Float, Float) {
    var scaleX: Float = 0
    var scaleY: Float = 0
    glfwGetWindowContentScale(pointer, &scaleX, &scaleY)
    return (scaleX, scaleY)
  }

  public func getWindowTitle() -> String {
    return String(cString: glfwGetWindowTitle(pointer))
  }

  public func setWindowTitle(_ title: String) {
    glfwSetWindowTitle(pointer, title)
  }

  public func getCursorPosition() -> (Double, Double) {
    var x: Double = 0
    var y: Double = 0
    glfwGetCursorPos(pointer, &x, &y)
    return (x, y)
  }

  public var windowShouldClose: Bool {
    get {
      return glfwWindowShouldClose(pointer) == GLFW_TRUE
    }
    set {
      glfwSetWindowShouldClose(pointer, newValue ? GLFW_TRUE : GLFW_FALSE)
    }
  }

  public func makeContextCurrent() {
    glfwMakeContextCurrent(pointer)
  }

  public func swapBuffers() {
    glfwSwapBuffers(pointer)
  }

  public func destroyWindow() {
    glfwDestroyWindow(pointer)
  }

  public func getWindowAttrib(_ attrib: Int32) -> Int32 {
    return glfwGetWindowAttrib(pointer, attrib)
  }

  public var isMinimized: Bool {
    return getWindowAttrib(GLFW_ICONIFIED) == GLFW_TRUE
  }

  public func iconify() {
    glfwIconifyWindow(pointer)
  }

  public func restore() {
    glfwRestoreWindow(pointer)
  }

  public func hide() {
    glfwHideWindow(pointer)
  }

  public func show() {
    glfwShowWindow(pointer)
  }
}
