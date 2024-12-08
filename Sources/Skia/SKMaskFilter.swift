import CSkia

public typealias SKMaskFilter = OpaquePointer

public func makeMaskFilter(blur: sk_blurstyle_t, sigma: Float) -> SKMaskFilter {
  return sk_maskfilter_new_blur(blur, sigma)
}

extension SKMaskFilter {
  public func unrefMaskFilter() {
    sk_maskfilter_unref(self)
  }
}
