import CSkia

public typealias SKSize = sk_size_t

extension SKSize {
  public static func make(_ w: Float, _ h: Float) -> SKSize {
    return SKSize(w: w, h: h)
  }
  public static func make(_ w: Int32, _ h: Int32) -> SKSize {
    return SKSize(w: Float(w), h: Float(h))
  }

  public var fwidth: Float { w }
  public var fheight: Float { h }

  public var width: Int32 { Int32(w) }
  public var height: Int32 { Int32(h) }
}
