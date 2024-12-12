import CSkia

public typealias SKPositionWithAffinity = sk_position_with_affinity_t
public typealias SKTextBox = sk_text_box_t
// public typealias SKRectHeightStyle = sk_rect_height_style_t
// public typealias SKRectWidthStyle = sk_rect_width_style_t
public enum SKRectHeightStyle: UInt32 {
  case tight = 0
  case max = 1
  case includeLineSpacingMiddle = 2
  case includeLineSpacingTop = 3
  case includeLineSpacingBottom = 4
}

public enum SKRectWidthStyle: UInt32 {
  case tight = 0
  case max = 1
}

public class SKParagraph {
  var pointer: OpaquePointer

  internal init(pointer: OpaquePointer) {
    self.pointer = pointer
  }

  public var height: Float {
    sk_paragraph_get_height(self.pointer)
  }

  public var maxWidth: Float {
    sk_paragraph_get_max_width(self.pointer)
  }

  public var minIntrinsicWidth: Float {
    sk_paragraph_get_min_intrinsic_width(self.pointer)
  }

  public var maxIntrinsicWidth: Float {
    sk_paragraph_get_max_intrinsic_width(self.pointer)
  }

  public var alphabeticBaseline: Float {
    sk_paragraph_get_alphabetic_baseline(self.pointer)
  }

  public var ideographicBaseline: Float {
    sk_paragraph_get_ideographic_baseline(self.pointer)
  }

  public var longestLine: Float {
    sk_paragraph_get_longest_line(self.pointer)
  }

  public var didExceedMaxLines: Bool {
    sk_paragraph_did_exceed_max_lines(self.pointer)
  }

  public func layout(width: Float) {
    sk_paragraph_layout(self.pointer, width)
  }

  public func markDirty() {
    sk_paragraph_mark_dirty(self.pointer)
  }

  public func getGlyphPositionAtCoordinate(x: Float, y: Float) -> SKPositionWithAffinity {
    return sk_paragraph_get_glyph_position_at_coordinate(self.pointer, x, y)
  }

  public func getRectsForRange(
    start: UInt32, end: UInt32, heightStyle: SKRectHeightStyle, widthStyle: SKRectWidthStyle
  ) -> [SKTextBox] {
    let rects = sk_paragraph_get_rects_for_range(
      self.pointer, start, end,
      sk_rect_height_style_t(rawValue: heightStyle.rawValue),
      sk_rect_width_style_t(rawValue: widthStyle.rawValue)
    )
    // create array from vector
    var res: [SKTextBox] = []
    for i in 0..<rects.size {
      res.append(rects.data[i])
    }
    return res
  }

  public func paint(canvas: SKCanvas, x: Float, y: Float) {
    sk_paragraph_paint(self.pointer, canvas.pointer, x, y)
  }
}
