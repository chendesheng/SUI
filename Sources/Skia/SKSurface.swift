import CSkia

public typealias SKSurface = OpaquePointer

extension SKSurface {
  public func getCanvas() -> SKCanvas? {
    return SKCanvas(sk_surface_get_canvas(self))
  }

  public func unrefSurface() {
    sk_surface_unref(self)
  }
}
