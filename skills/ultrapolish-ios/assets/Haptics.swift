import SwiftUI
import CoreHaptics

/*
 Haptics.swift

 Drop-in haptic vocabulary. Rename nothing. Adjust the signature pattern in
 `CoreHapticsPlayer.signature()` to the project's design contract (row 9).

 Everyday feedback goes through `.sensoryFeedback`; use the `Haptic` cases as
 the single source of which style fires where. Core Haptics is for the one or
 two moments that deserve a signature.
 */

// MARK: - Everyday feedback (.sensoryFeedback)

enum Haptic {
    /// Touch-down on any button. Never on release.
    static let press: SensoryFeedback = .impact(weight: .light)
    /// Picker, segmented control, a detent crossed. On the crossing, not per pixel.
    static let selection: SensoryFeedback = .selection
    /// Send, save, complete. Once per commit, never per item.
    static let success: SensoryFeedback = .success
    /// Entering a warning state: over a limit, dragged past cancel.
    static let warning: SensoryFeedback = .warning
    /// A failure. Always paired with inline copy, never alone.
    static let error: SensoryFeedback = .error
    /// Picking something up.
    static let pickUp: SensoryFeedback = .impact(flexibility: .soft, intensity: 0.7)
    /// Landing something. Heavier and duller than pick-up.
    static let land: SensoryFeedback = .impact(weight: .medium)
    /// Snapping to a detent.
    static let snap: SensoryFeedback = .impact(flexibility: .rigid)

    /// iPads have no haptic engine; use this to skip Core Haptics setup.
    static var isAvailable: Bool {
        CHHapticEngine.capabilitiesForHardware().supportsHaptics
    }
}

// MARK: - Signature moments (Core Haptics)

/// One warm engine for the whole app. Call `prepare()` about a second before a
/// predictable moment; it cuts latency from roughly 50ms to under 5ms and the
/// engine stays warm for about two seconds.
@MainActor
final class CoreHapticsPlayer {
    static let shared = CoreHapticsPlayer()

    private var engine: CHHapticEngine?
    private var lastTick: TimeInterval = 0
    private let tickThrottle: TimeInterval = 0.030

    private init() {
        guard Haptic.isAvailable else { return }
        engine = try? CHHapticEngine()
        engine?.playsHapticsOnly = true
        engine?.resetHandler = { [weak self] in try? self?.engine?.start() }
        engine?.stoppedHandler = { _ in }
    }

    /// Warm the engine ahead of a moment you can predict (a long-press, a capture).
    func prepare() {
        try? engine?.start()
    }

    /// Two transients: a soft touch then a firmer landing 85ms later. Reads as
    /// something materialising. Use for one signature moment, not for every card.
    func signature() {
        play([
            transient(intensity: 0.55, sharpness: 0.30, at: 0),
            transient(intensity: 0.90, sharpness: 0.55, at: 0.085),
        ])
    }

    /// A single transient scaled by how much is moving. Throttled to 30ms so a
    /// fast scrub or flip does not become a buzz. `density` is 0...1.
    func tick(density: Double) {
        let now = CACurrentMediaTime()
        guard now - lastTick >= tickThrottle else { return }
        lastTick = now
        let d = Float(min(max(density, 0), 1))
        play([transient(intensity: 0.35 + 0.35 * d, sharpness: 0.5 + 0.4 * d, at: 0)])
    }

    // MARK: Internals

    private func transient(intensity: Float, sharpness: Float, at time: TimeInterval) -> CHHapticEvent {
        CHHapticEvent(
            eventType: .hapticTransient,
            parameters: [
                CHHapticEventParameter(parameterID: .hapticIntensity, value: intensity),
                CHHapticEventParameter(parameterID: .hapticSharpness, value: sharpness),
            ],
            relativeTime: time
        )
    }

    private func play(_ events: [CHHapticEvent]) {
        guard let engine else { return }
        do {
            try engine.start()
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: CHHapticTimeImmediate)
        } catch {
            // Fall back silently; a missed signature is better than a crash.
        }
    }
}
