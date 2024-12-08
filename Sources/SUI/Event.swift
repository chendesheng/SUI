import GLFW
import Skia

public enum ViewEventType: Int {
  case Keypress = 0
  case Mousemove = 1
  case MouseDown = 2
  case MouseUp = 3
  case MouseEnter = 4
  case MouseLeave = 5
  case MouseWheel = 6
  case Click = 7
  case DblClick = 8
  case TplClick = 9
  case Resize = 10
  case WindowClose = 11
}

public enum ViewEvent {
  case Keypress(target: View, data: Key)
  case MouseDown(target: View, data: MouseEventData)
  case MouseUp(target: View, data: MouseEventData)
  case Mousemove(target: View, data: MouseEventData)
  case MouseEnter(target: View, data: MouseEventData)
  case MouseLeave(target: View, data: MouseEventData)
  case MouseWheel(target: View, data: MouseEventData)
  case Click(target: View, data: MouseEventData)
  case DblClick(target: View, data: MouseEventData)
  case TplClick(target: View, data: MouseEventData)
  case Resize(target: View, data: SKSize)
  case WindowClose(target: View)

  public var type: ViewEventType {
    switch self {
    case .Keypress:
      return .Keypress
    case .MouseDown:
      return .MouseDown
    case .MouseUp:
      return .MouseUp
    case .Mousemove:
      return .Mousemove
    case .MouseEnter:
      return .MouseEnter
    case .MouseLeave:
      return .MouseLeave
    case .MouseWheel:
      return .MouseWheel
    case .Click:
      return .Click
    case .DblClick:
      return .DblClick
    case .TplClick:
      return .TplClick
    case .Resize:
      return .Resize
    case .WindowClose:
      return .WindowClose
    }
  }
}

public class EventEmitter {
  private var handlers: [ViewEventType: [(ViewEvent) -> Void]] = [:]

  public func addEventListener(_ type: ViewEventType, _ handler: @escaping (ViewEvent) -> Void) {
    if handlers[type]?.contains(where: { $0 as AnyObject === handler as AnyObject }) ?? false {
      return
    }

    handlers[type, default: []].append(handler)
  }

  public func dispatchEvent(_ event: ViewEvent) {
    handlers[event.type, default: []].forEach { $0(event) }
  }

  public func removeEventListener(_ type: ViewEventType, _ handler: @escaping (ViewEvent) -> Void) {
    handlers[type]?.removeAll { $0 as AnyObject === handler as AnyObject }
  }
}

public struct MouseEventData {
  public var button: MouseButton
  public var position: SKPoint

  public init(button: MouseButton, position: SKPoint) {
    self.button = button
    self.position = position
  }
}
