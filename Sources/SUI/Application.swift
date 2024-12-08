import CGLFW3

public class Application {
  @MainActor public init() throws {
    glfwSetErrorCallback { message, _ in
      print("GLFW Error: \(message)")
    }

    if glfwInit() == GLFW_FALSE {
      throw RuntimeError.failedToInitializeGLFW
    }

    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 4)
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 1)
    glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GLFW_TRUE)
    glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE)
  }

  private var windows: [Window] = []
  private func registerWindow(_ window: Window) {
    if windows.contains(where: { $0 === window }) {
      return
    }

    windows.append(window)
  }

  public func createWindow(width: Int32, height: Int32, title: String) throws -> Window {
    guard let window = Window(width: width, height: height, title: title) else {
      throw RuntimeError.failedToCreateWindow
    }

    glfwSwapInterval(1)
    registerWindow(window)
    return window
  }

  public func run() {
    var hasClosedWindows = false

    while true {
      for window in windows {
        if window.isClosing {
          window.destroy()
          hasClosedWindows = true
          continue
        }

        window.render()
      }

      if hasClosedWindows {
        windows.removeAll { $0.isClosed }
        hasClosedWindows = false
      }

      if windows.isEmpty {
        break
      }

      glfwWaitEvents()
    }
  }
}
