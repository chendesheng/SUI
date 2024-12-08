import CSkia

public typealias SKColor = sk_color_t
public typealias SKColor4f = sk_color4f_t

extension SKColor {
  public func toColor4f() -> SKColor4f {
    var color4f = SKColor4f()
    sk_color4f_from_color(self, &color4f)
    return color4f
  }

  public func opacity() -> Float {
    return Float(self >> 24) / 255.0
  }

  public func setOpacity(_ opacity: Float) -> SKColor {
    return SKColor((UInt32(opacity * 255) << 24) | (self & 0x00_ff_ff_ff))
  }
}

func makeColor(r: UInt8, g: UInt8, b: UInt8, a: Float) -> SKColor {
  return SKColor(UInt8(a * 255) << 24 | r << 16 | g << 8 | b)
}

func makeColor(r: UInt8, g: UInt8, b: UInt8) -> SKColor {
  return SKColor(r << 16 | g << 8 | b)
}

public enum Colors: SKColor {
  case red = 0xff_ff_00_00
  case green = 0xff_00_ff_00
  case blue = 0xff_00_00_ff
  case black = 0xff_00_00_00
  case yellow = 0xff_ff_ff_00
  case purple = 0xff_ff_00_ff
  case orange = 0xff_ff_a5_00
  case pink = 0xff_ff_c0_cb
  case brown = 0xff_a5_2a_2a
  case silver = 0xff_c0_c0_c0
  case gray = 0xff_80_80_80
  case olive = 0xff_80_80_00
  case teal = 0xff_00_80_80
  case navy = 0xff_00_00_80
  case maroon = 0xff_80_00_00
  case white = 0xff_ff_ff_ff
  case gray40 = 0xff_66_66_66
}

extension SKColor4f {
  public func toColor() -> SKColor {
    var color = self
    return sk_color4f_to_color(&color)
  }
}

public func makeColor4f(r: Float, g: Float, b: Float, a: Float) -> SKColor4f {
  return SKColor4f(fR: r, fG: g, fB: b, fA: a)
}
