import CSkia

public class SKTextStyle {
  var pointer: OpaquePointer

  internal init(pointer: OpaquePointer) {
    self.pointer = pointer
  }
  public init() {
    self.pointer = sk_text_style_create()
  }

  public var color: SKColor {
    get { return sk_text_style_get_color(self.pointer) }
    set { sk_text_style_set_color(self.pointer, newValue) }
  }

  public var hasForeground: Bool {
    get { return sk_text_style_has_foreground(self.pointer) }
    set { sk_text_style_clear_foreground_color(self.pointer) }
  }

  public var foreground: SKPaint {
    get { return SKPaint(pointer: sk_text_style_get_foreground(self.pointer)) }
    set { sk_text_style_set_foreground_paint(self.pointer, newValue.pointer) }
  }

  public var hasBackground: Bool {
    get { return sk_text_style_has_background(self.pointer) }
    set { sk_text_style_clear_background_color(self.pointer) }
  }

  public var background: SKPaint {
    get { return SKPaint(pointer: sk_text_style_get_background(self.pointer)) }
    set { sk_text_style_set_background_paint(self.pointer, newValue.pointer) }
  }
}
