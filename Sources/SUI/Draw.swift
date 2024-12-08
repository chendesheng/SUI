import Skia

extension SKCanvas {
  func draw(rrect: SKRRect, paint: SKPaint, elevation: Bool = false) {
    if elevation {
      draw(shadow: rrect, paint: paint, blur: 0.5, offsetX: 0, offsetY: 0.5)
    }
    draw(rrect: rrect, paint: paint)
    if elevation {
      draw(innerShadow: rrect, color: .white32, blur: 0.5, offsetX: 0, offsetY: 0.5)
    }
  }

  func draw(popoutBackground: SKRRect) {
    let paint = SKPaint()
    paint.setAntiAlias(true)
    paint.setColor(.gray40)
    paint.setStyle(.fill)
    draw(rrect: popoutBackground, paint: paint)
  }
}
