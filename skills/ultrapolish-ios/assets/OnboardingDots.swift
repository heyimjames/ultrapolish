import SwiftUI

/*
 OnboardingDots.swift

 Progress as dots, never a bar. The active dot is a capsule about 3× the width
 of the others and glides to the new index on `Motion.settle`. Inactive dots
 sit at 0.25 opacity of the ink colour. The dots are hidden from VoiceOver;
 the container carries "Step n of m".

 Requires Motion.swift. Tint with `.foregroundStyle(project.ink)`.

 Usage:
   OnboardingDots(count: 4, index: page)
 */

struct OnboardingDots: View {
    let count: Int
    let index: Int
    var dotSize: CGFloat = 8
    var activeWidthMultiplier: CGFloat = 3
    var spacing: CGFloat = 8

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        HStack(spacing: spacing) {
            ForEach(0..<count, id: \.self) { i in
                Capsule(style: .continuous)
                    .frame(width: i == index ? dotSize * activeWidthMultiplier : dotSize,
                           height: dotSize)
                    .opacity(i == index ? 1 : 0.25)
            }
        }
        .animation(reduceMotion ? Motion.reduced : Motion.settle, value: index)
        .accessibilityHidden(true)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Progress")
        .accessibilityValue("Step \(min(index + 1, count)) of \(count)")
    }
}
