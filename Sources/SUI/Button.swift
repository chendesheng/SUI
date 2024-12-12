import Skia
import Yoga

public class Button: View {
  private var isPressed: Bool = false
  private let isPrimary: Bool
  private var font: SKFont

  private var textView: TextView? {
    return children.first { $0 is TextView } as? TextView
  }

  var text: String {
    get {
      return textView?.data ?? ""
    }
    set {
      if let textView = textView {
        textView.data = newValue
      }
    }
  }

  public init(text: String, isPrimary: Bool = false) {
    self.isPrimary = isPrimary
    let typeface = SKTypeface(file: "/Library/Fonts/SF-Pro.ttf")
    font = SKFont(typeface: typeface, size: 14)

    super.init()

    node.setWidth(100)
    node.setHeight(20)
    node.setPadding(.horizontal, 20)
    node.setJustifyContent(.center)
    node.setAlignItems(.center)
    node.setFlexGrow(0)

    appendChild(TextView(data: text, color: .white))
  }

  override public var borderRadius: Float? {
    return 6
  }

  override public func drawSelf(_ canvas: SKCanvas) {
    let height = nodeHeight
    let lightenFactor: Float = isPressed ? 0.05 : 0
    let paint = SKPaint(color: isPressed ? .green : .red)
    paint.setAntiAlias(true)
    if isPrimary {
      let linearGradient = SKLinearGradient(
        start: SKPoint(x: 0, y: 0),
        end: SKPoint(x: 0, y: height),
        colors: [
          .buttonGradientStart.lighten(lightenFactor),
          .buttonGradientEnd.lighten(lightenFactor),
        ],
        colorPos: [0, 1]
      )
      paint.setShader(SKShader(linearGradient: linearGradient))
    } else {
      paint.setColor(.gray94.lighten(lightenFactor))
    }
    canvas.draw(rrect: nodeRectRounded, paint: paint, elevation: true)
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
