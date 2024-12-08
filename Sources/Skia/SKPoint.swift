import CSkia

public typealias SKPoint = sk_point_t
public typealias SKVector = sk_vector_t

extension SKPoint {
  public static func make(_ x: Float, _ y: Float) -> SKPoint {
    return sk_point_t(x: x, y: y)
  }
}
