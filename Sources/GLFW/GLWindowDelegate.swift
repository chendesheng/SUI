public protocol GLWindowDelegate: AnyObject {
  func handleResize(width: Int32, height: Int32)
  func handleKey(key: Key, action: GLFWAction)
  func handleMouseButton(button: MouseButton, action: GLFWAction, position: (Double, Double))
  func handleClose()
  func handleFramebufferResize(width: Int32, height: Int32)
}
