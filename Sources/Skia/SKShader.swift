import CSkia

public class SKShader {
  let pointer: OpaquePointer

  public init() {
    self.pointer = sk_shader_new_empty()
  }

  public init(color: SKColor) {
    self.pointer = sk_shader_new_color(color)
  }

  public init(color4f: SKColor4f) {
    var color4f = color4f
    self.pointer = sk_shader_new_color4f(&color4f, nil)
  }

  public init(
    linearGradient: SKLinearGradient,
    tileMode: sk_shader_tilemode_t = CLAMP_SK_SHADER_TILEMODE
  ) {
    self.pointer = sk_shader_new_linear_gradient(
      [linearGradient.start, linearGradient.end],
      linearGradient.colors,
      linearGradient.colorPos,
      Int32(linearGradient.colors.count),
      tileMode,
      nil
    )
  }

  deinit {
    sk_shader_unref(pointer)
  }
}

public struct SKLinearGradient {
  public let start: SKPoint
  public let end: SKPoint
  public let colors: [SKColor]
  public let colorPos: [Float]?

  public init(
    start: SKPoint,
    end: SKPoint,
    colors: [SKColor],
    colorPos: [Float]?
  ) {
    self.start = start
    self.end = end
    self.colors = colors
    self.colorPos = colorPos
  }
}
