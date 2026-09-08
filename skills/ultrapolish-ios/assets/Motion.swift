import SwiftUI

/*
 Motion.swift

 Drop-in motion vocabulary. Rename nothing; adjust the numbers to the project's
 design contract (row 8) and keep the job comments accurate.

 One rule: if a new animation does not fit one of these curves, the answer is
 usually "don't". Add a curve only when it has a job no existing curve does.

 ────────────────────────────────────────────────────────────
 MOTION STORYBOARD (fill in for your app; keep it above the constants)

 Read top to bottom. Each value is ms after the trigger.
 Motion is earned: frequent moments are near-instant, rare ones get theatre.

 LAUNCH (once per cold start)
      0ms   first screen's chrome already in place
     60ms   content fades in (fade)
    120ms   rows arrive, stagger 40ms, first appearance only (reveal)

 PRESS (hundreds of times a day)
      0ms   touch-down: scale 1.0 → 0.97, light haptic      (press, 160ms, no bounce)
  release   scale 0.97 → 1.0                                 (release, 300ms, bounce 0.25)

 STATE CHANGE (toggle, chip, tab indicator)
      0ms   crossfade or slide, never a pop                  (state, 240ms)

 SHEET
      0ms   container rises                                  (settle, 420ms, bounce 0.18)
     80ms   contents fade in, stagger 30ms
  dismiss   container drops                                  (exit, 320ms, no bounce)

 NAVIGATION
   deeper   destination grows in from 0.94                   (navigate, 380ms)
  shallower destination shrinks in from 1.04                 (navigate, 380ms)

 ERROR (in context, not a toast in the sky)
      0ms   strip rises from the failing element             (settle)
   4000ms   strip sinks away                                 (exit)

 REDUCED MOTION: no scale, no travel, no stagger. Opacity and colour only.
 ────────────────────────────────────────────────────────────
 */

enum Motion {

    // MARK: Curves

    /// Touch-down feedback. Fires hundreds of times a day; near-instant, no bounce.
    static let press = Animation.spring(duration: 0.16, bounce: 0)

    /// Touch-up return. The one place a whisper of bounce belongs.
    static let release = Animation.spring(duration: 0.30, bounce: 0.25)

    /// Yes/no state: toggles, chips, tab indicators, selection rings.
    static let state = Animation.snappy(duration: 0.24, extraBounce: 0.08)

    /// Mode changes and label crossfades. Nothing travels; opacity never springs.
    static let mode = Animation.smooth(duration: 0.22)

    /// Weighted objects arriving or returning: sheets, cards after a drag, a strip rising.
    static let settle = Animation.spring(duration: 0.42, bounce: 0.18)

    /// Anything leaving. Out is faster than in and never bouncier.
    static let exit = Animation.spring(duration: 0.32, bounce: 0)

    /// Hero and reveal moments: matched geometry, a card unfolding. The one overshoot.
    static let reveal = Animation.spring(duration: 0.42, bounce: 0.16)

    /// An image or object travelling between places. Better damped than `reveal`
    /// because it carries content and must not wobble.
    static let fly = Animation.spring(duration: 0.34, bounce: 0.08)

    /// Push and pop. Deeper grows in from 0.94; shallower shrinks in from 1.04.
    static let navigate = Animation.spring(duration: 0.38, bounce: 0.05)

    /// Pure opacity: thumbnails arriving, captions, the first-appearance stagger.
    static let fade = Animation.easeOut(duration: 0.30)

    /// Progress that tracks a real number. It is a number, so it moves linearly.
    static let progress = Animation.linear(duration: 0.18)

    /// Reduce Motion stand-in for anything that would otherwise travel or scale.
    static let reduced = Animation.easeInOut(duration: 0.18)

    // MARK: Element configs

    enum Scale {
        static let pressed: CGFloat = 0.97
        static let pressedRow: CGFloat = 0.99
        static let pressedIcon: CGFloat = 0.94
        static let navigateDeeperFrom: CGFloat = 0.94
        static let navigateShallowerFrom: CGFloat = 1.04
    }

    enum Timing {
        /// Milliseconds between staggered siblings on first appearance.
        static let stagger: Double = 40
        /// Maximum siblings that stagger; the rest arrive with the last one.
        static let staggerCap = 8
        /// Contents of a sheet arrive this long after the container.
        static let sheetContentOffset: Double = 80
        /// How long an in-context error strip dwells before sinking.
        static let errorDwell: Double = 4000
    }

    // MARK: Helpers

    /// Delay for the `index`-th sibling on first appearance. Capped so the last
    /// item never arrives after the user has already looked at it.
    static func stagger(index: Int, step: Double = Timing.stagger, cap: Int = Timing.staggerCap) -> Double {
        Double(min(index, cap)) * step / 1000
    }

    /// The curve to use given the Reduce Motion setting.
    static func respecting(_ reduceMotion: Bool, _ animation: Animation) -> Animation {
        reduceMotion ? reduced : animation
    }

    /// Exit curve derived from an entrance duration: 0.65× the time, no bounce.
    static func exitOf(duration: Double) -> Animation {
        .spring(duration: duration * 0.65, bounce: 0)
    }
}
