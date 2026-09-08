import SwiftUI

/*
 Shimmer.swift

 A skeleton shimmer driven by `TimelineView(.animation)`, not a Timer. Seamless
 loop, 1.4s period, subtle by default. Static under Reduce Motion.

 Usage:
   RoundedRectangle(cornerRadius: 8).fill(.quaternary).frame(height: 14).shimmer()

 The skeleton must structurally match the content it stands in for: same bar
 count, same widths, same positions.
 */

struct Shimmer: ViewModifier {
    var period: Double = 1.4
    var bandWidth: CGFloat = 0.35
    var intensity: Double = 0.18

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    func body(content: Content) -> some View {
        if reduceMotion {
            content
        } else {
            content.overlay {
                TimelineView(.animation) { context in
                    let t = context.date.timeIntervalSinceReferenceDate
                    let phase = (t.truncatingRemainder(dividingBy: period)) / period
                    GeometryReader { geo in
                        let w = geo.size.width
                        // Travel from fully off the leading edge to fully off the trailing edge
                        // so the loop has no visible seam.
                        let x = -w * bandWidth + (w * (1 + bandWidth)) * phase
                        LinearGradient(
                            stops: [
                                .init(color: .white.opacity(0), location: 0),
                                .init(color: .white.opacity(intensity), location: 0.5),
                                .init(color: .white.opacity(0), location: 1),
                            ],
                            startPoint: .leading, endPoint: .trailing
                        )
                        .frame(width: w * bandWidth)
                        .offset(x: x)
                    }
                }
                .blendMode(.plusLighter)
                .allowsHitTesting(false)
            }
            .clipped()
        }
    }
}

extension View {
    func shimmer(period: Double = 1.4) -> some View {
        modifier(Shimmer(period: period))
    }
}
