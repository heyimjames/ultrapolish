import SwiftUI
import UIKit

/*
 DisplayP3Color.swift

 Colour helpers that make the right thing the easy thing:
 - `Color(p3:)` so a hex literal lands in Display P3, never in sRGB by accident.
 - `Color.pair(light:dark:)` so every token is a light/dark pair, hand-tuned per mode.
 - `OKLCH.color(l:c:h:)` so palettes are picked perceptually and shipped in P3.

 Rename nothing. Put the project's tokens in a separate file that calls these.
 */

extension Color {
    /// A Display P3 colour from a 0xRRGGBB literal.
    init(p3 hex: UInt32, opacity: Double = 1) {
        let r = Double((hex >> 16) & 0xFF) / 255
        let g = Double((hex >> 8) & 0xFF) / 255
        let b = Double(hex & 0xFF) / 255
        self.init(.displayP3, red: r, green: g, blue: b, opacity: opacity)
    }

    /// A colour that resolves per appearance. Hand-tune both; do not derive one from the other.
    static func pair(light: UInt32, dark: UInt32) -> Color {
        Color(UIColor { trait in
            let hex = trait.userInterfaceStyle == .dark ? dark : light
            return UIColor(
                displayP3Red: CGFloat((hex >> 16) & 0xFF) / 255,
                green: CGFloat((hex >> 8) & 0xFF) / 255,
                blue: CGFloat(hex & 0xFF) / 255,
                alpha: 1
            )
        })
    }
}

/// OKLCH → Display P3. Pick in OKLCH (perceptual lightness, chroma, hue),
/// ship in P3. Matrices from Björn Ottosson (OKLab) and the standard
/// sRGB → P3 linear transform (both D65). Out-of-gamut values are clipped.
enum OKLCH {
    static func color(l: Double, c: Double, h: Double, opacity: Double = 1) -> Color {
        let (r, g, b) = p3(l: l, c: c, h: h)
        return Color(.displayP3, red: r, green: g, blue: b, opacity: opacity)
    }

    /// Gamma-encoded Display P3 components, each clipped to 0...1.
    static func p3(l: Double, c: Double, h: Double) -> (Double, Double, Double) {
        let hr = h * .pi / 180
        let a = c * cos(hr)
        let b = c * sin(hr)

        // OKLab → LMS (cube roots)
        let l_ = l + 0.3963377774 * a + 0.2158037573 * b
        let m_ = l - 0.1055613458 * a - 0.0638541728 * b
        let s_ = l - 0.0894841775 * a - 1.2914855480 * b
        let L = l_ * l_ * l_
        let M = m_ * m_ * m_
        let S = s_ * s_ * s_

        // LMS → linear sRGB
        let rl =  4.0767416621 * L - 3.3077115913 * M + 0.2309699292 * S
        let gl = -1.2684380046 * L + 2.6097574011 * M - 0.3413193965 * S
        let bl = -0.0041960863 * L - 0.7034186147 * M + 1.7076147010 * S

        // linear sRGB → linear Display P3 (D65)
        let rp = 0.8224621 * rl + 0.1775380 * gl
        let gp = 0.0331941 * rl + 0.9668058 * gl
        let bp = 0.0170827 * rl + 0.0723974 * gl + 0.9105199 * bl

        return (encode(rp), encode(gp), encode(bp))
    }

    /// Interpolate two OKLCH colours the short way round the hue circle.
    /// Use for gradient stops so yellow → blue does not pass through grey.
    static func stops(from a: (l: Double, c: Double, h: Double),
                      to b: (l: Double, c: Double, h: Double),
                      count: Int) -> [Color] {
        guard count > 1 else { return [color(l: a.l, c: a.c, h: a.h)] }
        var dh = b.h - a.h
        if dh > 180 { dh -= 360 } else if dh < -180 { dh += 360 }
        return (0..<count).map { i in
            let t = Double(i) / Double(count - 1)
            return color(l: a.l + (b.l - a.l) * t, c: a.c + (b.c - a.c) * t, h: a.h + dh * t)
        }
    }

    private static func encode(_ v: Double) -> Double {
        let x = min(max(v, 0), 1)
        return x <= 0.0031308 ? 12.92 * x : 1.055 * pow(x, 1 / 2.4) - 0.055
    }
}
