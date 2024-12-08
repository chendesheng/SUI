// The Swift Programming Language
// https://docs.swift.org/swift-book
import SUI

let app = try Application()
let window = try app.createWindow(width: 800, height: 600, title: "Hello World")
let button = Button(title: "Hello", isPrimary: true)
button.addEventListener(.Click) { event in
    print("click")
    let win = try! app.createWindow(width: 800, height: 600, title: "Hello World2")
    win.appendChild(Button(title: "Hello2"))
}
window.appendChild(button)
window.addEventListener(.Keypress) { event in
    if case let .Keypress(_, key) = event {
        if key == .Escape {
            window.close()
        }
    }
}

app.run()
