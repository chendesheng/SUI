import CSkia

public typealias SKRect = sk_rect_t
public typealias SKRRect = OpaquePointer

public func makeRect(pos: SKPoint, size: SKSize) -> SKRect {
  return SKRect(left: pos.x, top: pos.y, right: pos.x + size.w, bottom: pos.y + size.h)
}

extension SKRect {
  public var x: Float { left }
  public var y: Float { top }
  public var width: Float { right - left }
  public var height: Float { bottom - top }
  public var size: SKSize { SKSize.make(width, height) }
  public var point: SKPoint { SKPoint.make(left, top) }

  public func outer(x: Float, y: Float) -> SKRect {
    return SKRect(left: left - x, top: top - y, right: right + x, bottom: bottom + y)
  }

  public func outer(_ x: Float) -> SKRect {
    return outer(x: x, y: x)
  }

  public func translate(x: Float, y: Float) -> SKRect {
    if x == 0 && y == 0 {
      return self
    }

    return SKRect(left: left + x, top: top + y, right: right + x, bottom: bottom + y)
  }

  public func translate(x: Int32, y: Int32) -> SKRect {
    return translate(x: Float(x), y: Float(y))
  }

  public func merge(_ rect: SKRect) -> SKRect {
    return SKRect(
      left: min(left, rect.left),
      top: min(top, rect.top),
      right: max(right, rect.right),
      bottom: max(bottom, rect.bottom)
    )
  }

  public func isIntersect(_ rect: SKRect) -> Bool {
    return left < rect.right && right > rect.left && top < rect.bottom && bottom > rect.top
  }

  public var isEmpty: Bool {
    return left >= right || top >= bottom
  }

  public func toRRect() -> SKRRect {
    return rounded(x: 0, y: 0)
  }

  public func toRRect(radii: SKVector) -> SKRRect {
    let rrect = sk_rrect_new()!

    var rect = self
    sk_rrect_set_rect(rrect, &rect)

    var mutableRadii = radii
    sk_rrect_set_rect_radii(rrect, &rect, &mutableRadii)
    return rrect
  }

  public func toPath() -> SKPath {
    let path = SKPath()
    path.add(rect: self, direction: CW_SK_PATH_DIRECTION)
    return path
  }

  public func rounded(x: Float, y: Float) -> SKRRect {
    let rrect = sk_rrect_new()!
    var radii = sk_vector_t(x: x, y: y)
    var rect = self
    sk_rrect_set_rect_radii(rrect, &rect, &radii)
    return rrect
  }

  public func contains(_ point: SKPoint) -> Bool {
    point.x >= left && point.x <= right && point.y >= top && point.y <= bottom
  }

  public static func make(width: Float, height: Float) -> SKRect {
    return SKRect(left: 0, top: 0, right: width, bottom: height)
  }
}

extension SKRRect {
  public var rect: SKRect {
    var rect = SKRect()
    sk_rrect_get_rect(self, &rect)
    return rect
  }

  public func getRadii(corner: sk_rrect_corner_t) -> SKVector {
    var radii = SKVector()
    sk_rrect_get_radii(self, corner, &radii)
    return radii
  }

  public func outset(dx: Float, dy: Float) -> SKRRect {
    sk_rrect_outset(self, dx, dy)
    return self
  }

  public func offset(dx: Float, dy: Float) -> SKRRect {
    sk_rrect_offset(self, dx, dy)
    return self
  }

  public func offset(dx: Int32, dy: Int32) -> SKRRect {
    offset(dx: Float(dx), dy: Float(dy))
  }
}
