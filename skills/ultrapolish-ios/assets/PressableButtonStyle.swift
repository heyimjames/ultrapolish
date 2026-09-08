import SwiftUI

/*
 PressableButtonStyle.swift

 The default button feel: scale 0.97, opacity 0.9, `Motion.press` on the way
 down and `Motion.release` on the way up, a light haptic on touch-down only.
 Requires Motion.swift and Haptics.swift.

 Usage:
   Button("Save") { ... }.buttonStyle(.pressable)
   Button { ... } label: { Icon() }.buttonStyle(.pressable(scale: Motion.Scale.pressedIcon))
   Button("Row") { ... }.buttonStyle(.pressable(static: true))   // no motion, still a haptic
 */

struct PressableButtonStyle: ButtonStyle {
    /// Scale when pressed. Rows 0.99, surfaces 0.97, small icons 0.94. Never below 0.90.
    var scale: CGFloat = Motion.Scale.pressed
    /// Opacity when pressed.
    var opacity: Double = 0.9
    /// Skip the scale and opacity change (for high-frequency controls) but keep the haptic.
    var isStatic: Bool = false
    /// Fire the touch-down haptic.
    var haptic: Bool = true

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    func makeBody(configuration: Configuration) -> some View {
        let pressed = configuration.isPressed
        let animate = !isStatic && !reduceMotion
        return configuration.label
            .scaleEffect(animate && pressed ? scale : 1)
            .opacity(animate && pressed ? opacity : 1)
            .animation(pressed ? Motion.press : Motion.release, value: pressed)
            .sensoryFeedback(Haptic.press, trigger: pressed) { _, isNowPressed in
                haptic && isNowPressed   // touch-down only, never release
            }
    }
}

extension ButtonStyle where Self == PressableButtonStyle {
    /// The default pressable feel.
    static var pressable: PressableButtonStyle { PressableButtonStyle() }

    /// Pressable with a custom scale (for icon buttons or rows).
    static func pressable(scale: CGFloat) -> PressableButtonStyle {
        PressableButtonStyle(scale: max(scale, 0.90))
    }

    /// Haptic only; no visual change. For controls used 100+ times a day.
    static func pressable(static isStatic: Bool) -> PressableButtonStyle {
        PressableButtonStyle(isStatic: isStatic)
    }
}
