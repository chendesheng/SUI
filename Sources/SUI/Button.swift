import Skia
import Yoga

public class Button: View {
  private let title: String
  private var isPressed: Bool = false

  public init(title: String) {
    self.title = title
    super.init()

    node.setWidth(100)
    node.setHeight(30)
  }

  override public func drawSelf(_ canvas: SKCanvas) {
    let paint = SKPaint(color: isPressed ? .green : .red)
    canvas.draw(rect: nodeRect, paint: paint)

    // sk_canvas_draw_simple_text(
    //   canvas, title, title.utf8.count, UTF8_SK_TEXT_ENCODING, 0, 0, paint, nil)
  }

  override public func dispatchEvent(_ event: ViewEvent) {
    switch event {
    case .MouseDown:
      isPressed = true
    case .MouseUp:
      isPressed = false
    default:
      break
    }
    super.dispatchEvent(event)
  }
}
