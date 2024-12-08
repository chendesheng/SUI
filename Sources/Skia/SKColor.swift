import CSkia

public typealias SKColor = sk_color_t
public typealias SKColor4f = sk_color4f_t

extension SKColor {
  public func toColor4f() -> SKColor4f {
    var color4f = SKColor4f()
    sk_color4f_from_color(self, &color4f)
    return color4f
  }

  var r: UInt8 {
    return UInt8(self >> 16)
  }

  var g: UInt8 {
    return UInt8(self >> 8)
  }

  var b: UInt8 {
    return UInt8(self)
  }

  public func opacity() -> Float {
    return Float(self >> 24) / 255.0
  }

  public func setOpacity(_ opacity: Float) -> SKColor {
    return SKColor((UInt32(opacity * 255) << 24) | (self & 0x00_ff_ff_ff))
  }

  public func lighten(_ factor: Float) -> SKColor {
    if factor == 0 {
      return self
    }

    let (h, s, l) = rgbToHsl(r: r, g: g, b: b)
    let (r, g, b) = hslToRgb(h: h, s: s, l: l + factor)
    return makeColor(r: r, g: g, b: b, a: 1)
  }
}

func rgbToHsl(r: UInt8, g: UInt8, b: UInt8) -> (Float, Float, Float) {
  let r = Float(r) / 255
  let g = Float(g) / 255
  let b = Float(b) / 255

  let max = max(r, g, b)
  let min = min(r, g, b)
  var h: Float
  var s: Float
  let l = (max + min) / 2

  if max == min {
    h = 0
    s = 0  // achromatic
  } else {
    let d = max - min
    s = l > 0.5 ? d / (2 - max - min) : d / (max + min)

    switch max {
    case r:
      h = (g - b) / d + (g < b ? 6 : 0)
    case g:
      h = (b - r) / d + 2
    case b:
      h = (r - g) / d + 4
    default:
      h = 0
    }

    h = h / 6
  }

  return (h, s, l)
}

func hslToRgb(h: Float, s: Float, l: Float) -> (UInt8, UInt8, UInt8) {
  var r: Float
  var g: Float
  var b: Float

  if s == 0 {
    r = l
    g = l
    b = l  // achromatic
  } else {
    func hue2rgb(_ p: Float, _ q: Float, _ t: Float) -> Float {
      var t = t
      if t < 0 { t += 1 }
      if t > 1 { t -= 1 }
      if t < 1 / 6 { return p + (q - p) * 6 * t }
      if t < 1 / 2 { return q }
      if t < 2 / 3 { return p + (q - p) * (2 / 3 - t) * 6 }
      return p
    }

    let q = l < 0.5 ? l * (1 + s) : l + s - l * s
    let p = 2 * l - q

    r = hue2rgb(p, q, h + 1 / 3)
    g = hue2rgb(p, q, h)
    b = hue2rgb(p, q, h - 1 / 3)
  }

  return (UInt8(r * 255), UInt8(g * 255), UInt8(b * 255))
}

public func makeColor(gray: UInt32, a: Float = 1.0) -> SKColor {
  let r = gray
  let g = gray << 8
  let b = gray << 16
  let a = UInt32(a * 255) << 24
  return SKColor(a | r | g | b)
}

public func makeColor(r: UInt8, g: UInt8, b: UInt8, a: Float = 1) -> SKColor {
  let a = UInt32(a * 255) << 24
  let r = UInt32(r) << 16
  let g = UInt32(g) << 8
  let b = UInt32(b)
  return SKColor(a | r | g | b)
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
