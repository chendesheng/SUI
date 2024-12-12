import Skia
import Yoga

public class TextView: View {
  public var font: SKFont
  public var fontStyle: SKFontStyle
  public var data: String

  var selection: Range<Int>

  private func getSortedSelection() -> Range<Int> {
    if selection.lowerBound > selection.upperBound {
      return selection.upperBound..<selection.lowerBound
    }
    return selection
  }

  func isInSelection(pos: Int) -> Bool {
    return selection.contains(pos)
  }

  func getSelectionRect(paragraph: SKParagraph) -> SKRect {
    let range = getSortedSelection()
    let rects = paragraph.getRectsForRange(
      start: UInt32(range.lowerBound), end: UInt32(range.upperBound),
      heightStyle: .includeLineSpacingMiddle, widthStyle: .tight)
    return rects[0].rect
  }

  var fontSize: Float {
    get {
      return font.size
    }
    set {
      if newValue == font.size {
        return
      }

      font.size = newValue
    }
  }

  public var color: SKColor
  private var underline: Bool = false

  private func getCharPosition(paragraph: SKParagraph, x: Float) -> Int32 {
    let position = paragraph.getGlyphPositionAtCoordinate(x: x, y: 0)
    return position.position
  }

  private func getPxFromCharPosition(paragraph: SKParagraph, position: Int32) -> Float {
    if position == 0 {
      return 0
    }

    if position >= data.count {
      return paragraph.maxIntrinsicWidth
    }

    let rects = paragraph.getRectsForRange(
      start: UInt32(position), end: UInt32(position + 1), heightStyle: .includeLineSpacingMiddle,
      widthStyle: .tight)
    return rects[0].rect.left
  }

  override public var interactive: Bool {
    return true
  }

  private func createParagraphBuilder() -> SKParagraphBuilder {
    let fontCollection = SKFontCollection()
    fontCollection.setDefaultFontManager(SKFontMgr())
    let paragraphStyle = SKParagraphStyle()
    let builder = SKParagraphBuilder(paragraphStyle: paragraphStyle, fontCollection: fontCollection)
    builder.add(text: data)
    return builder
  }

  public init(data: String, color: SKColor) {
    self.data = data

    let typeface = SKTypeface(file: "/Library/Fonts/SF-Pro.ttf")
    self.font = SKFont(typeface: typeface, size: 14)
    self.fontStyle = .bold

    self.color = color
    self.selection = 0..<0
    super.init()

    self.node.setFlexGrow(0)
    self.node.setFlexShrink(1)
  }

  override public func draw(_ canvas: SKCanvas) {
    if self.hidden {
      return
    }

    let builder = createParagraphBuilder()
    let paragraph = builder.build()

    if !selection.isEmpty {
      let range = getSortedSelection()
      let paint = SKPaint(color: .blue)
      let path = SKPath()
      for r in paragraph.getRectsForRange(
        start: UInt32(range.lowerBound), end: UInt32(range.upperBound),
        heightStyle: .includeLineSpacingMiddle, widthStyle: .tight)
      {
        path.add(rect: r.rect)
      }
      canvas.draw(path: path, paint: paint)
    }
    paragraph.layout(width: nodeWidth)
    canvas.draw(paragraph: paragraph, x: 0, y: 0)
  }

  public func replaceText(start: Int, end: Int, text: String) {
    // let value = data
    // let before = value[..<start]
    // let after = value[end...]
    // data = before + text + after
  }

  public func insertText(text: String) {
    // let value = data
    // let before = value[..<selection.lowerBound]
    // let after = value[selection.upperBound...]
    // data = before + text + after
  }
}
