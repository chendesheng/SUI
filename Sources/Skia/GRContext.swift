import CSkia

public typealias GRContext = OpaquePointer

extension GRContext {
  public static func createContext() -> GRContext? {
    let interface = gr_glinterface_create_native_interface()
    if interface == nil {
      print("Failed to create GL interface")
      return nil
    }
    let ctx = gr_direct_context_make_gl(interface)
    if ctx == nil {
      print("Failed to create direct context")
      return nil
    }
    return ctx
  }

  public func createSurface(width: Int32, height: Int32) -> SKSurface? {
    var buffer_info = gr_gl_framebufferinfo_t(fFBOID: 0, fFormat: 0x8058, fProtected: false)
    let backend_render_target = gr_backendrendertarget_new_gl(
      width, height, 0, 0, &buffer_info)
    let surface = sk_surface_new_backend_render_target(
      self, backend_render_target, BOTTOM_LEFT_GR_SURFACE_ORIGIN, RGBA_8888_SK_COLORTYPE, nil, nil
    )
    if surface == nil {
      print("Failed to create surface")
      return nil
    }
    return surface
  }

  public func freeGpuResources() {
    gr_direct_context_free_gpu_resources(self)
  }
}
