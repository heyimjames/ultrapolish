# Sound

Use this when adding or auditing UI sound: which moments get a cue, how loud, through which audio session, and how the user turns it off.
Sound is the rarest channel and the easiest to get wrong. A few short cues on meaningful beats make an app feel physical; a cue on every tap makes it feel like a toy.

## Rules

1. **Three to five cues, each under 200ms.** More than five and the user cannot tell them apart; longer than 200ms and it becomes music. Check: list the cues; each has a name, a moment, and a duration you can state.
2. **Only meaningful beats get sound.** Something you did landed (sent, saved, completed), a rare milestone. Frequent, noisy actions (typing, scrolling, toggling, tapping rows) stay silent. Check: on the primary path, count sounds; expect one to three.
3. **Each cue has its own volume.** A milestone may be fuller (0.5); a success is quiet (0.34); everything else quieter still (0.24). One global level makes the small moments too loud or the big one too small. Check: every cue defines a volume.
4. **Use the `.ambient` category with `.mixWithOthers`.** This respects the Ring/Silent switch, never ducks music or podcasts, and never interrupts a call. Any other category makes your app the thing that interrupted someone's music. Check: play a podcast, trigger a cue; the podcast does not dip.
5. **Land within 10ms of the paired haptic.** Trigger both from the same call, with the player already prepared (`prepareToPlay()`). A late sound reads as a second event. Check: the two feel like one.
6. **Ship a toggle, default on, in Settings.** Sound is personal. The toggle lives with the app's other feedback settings, not buried under Advanced. Check: turn it off; every cue is silent, including system-sound fallbacks.
7. **Resolve cues by name so a designer can upgrade them without code.** Look for `<cue>.caf` (then `.wav`, `.m4a`, `.aif`) in the bundle; fall back to a restrained system sound ID. Dropping a licensed file into the bundle upgrades a cue. Check: rename a bundled file; the cue falls back cleanly.
8. **Synthesise when the sound must never repeat exactly.** Mechanical or physical apps (flip boards, dials, shutters) can generate cues at launch from filtered noise, a damped ring, and a low thud, with per-variant randomisation. Zero bundle weight, infinite variance. Check: trigger the same cue ten times; no two are identical.
9. **Throttle and scale with density, like haptics.** Many events at once become one softer flutter, not many loud ticks: minimum gap 18–28ms as density rises, level `0.28 + 0.42 × density`. Check: a cascade reads as one texture.
10. **Attack over 1.5ms, never from sample zero.** A cue that starts at full amplitude clicks. Check: listen on headphones; no click at the start.
11. **Know when sound is wrong.** Productivity tools, reading apps, finance, anything used in meetings: default to no sound at all, and never for errors. Check: the design contract states "Sound: none" explicitly when that is the decision.

## Cheat sheet

| Cue | Moment | Volume | System fallback |
|---|---|---|---|
| send | you sent something | 0.24 | 1004 |
| success | an action committed | 0.34 | 1057 (Tink) |
| save | something was kept | 0.24 | 1103 |
| celebrate | a rare milestone | 0.5 | 1025 |

| Setting | Value |
|---|---|
| Category | `.ambient`, options `[.mixWithOthers]` |
| Max duration | 200ms |
| Cue count | 3–5 |
| Sync with haptic | ≤ 10ms |
| Attack | 1.5ms |
| Throttle under load | 18–28ms gap, density-scaled level |
| Toggle | Settings, default on |

## Code

### A cue player with bundled override and system fallback

```swift
import AVFoundation
import AudioToolbox

@MainActor
final class SoundFX {
    static let shared = SoundFX()
    private init() {}

    enum Cue: String, CaseIterable {
        case send, success, save, celebrate

        var systemID: SystemSoundID {
            switch self {
            case .send: 1004
            case .success: 1057
            case .save: 1103
            case .celebrate: 1025
            }
        }
        var volume: Float {
            switch self {
            case .celebrate: 0.5
            case .success: 0.34
            default: 0.24
            }
        }
    }

    var enabled: Bool { UserDefaults.standard.object(forKey: "soundEffects") as? Bool ?? true }

    private var players: [Cue: AVAudioPlayer] = [:]
    private var sessionReady = false

    func play(_ cue: Cue) {
        guard enabled else { return }
        if let player = player(for: cue) {
            prepareSession()
            player.volume = cue.volume
            player.currentTime = 0
            player.play()
        } else {
            AudioServicesPlaySystemSound(cue.systemID)
        }
    }

    /// Prepare the players you will need in the next second, so the cue lands with its haptic.
    func warm(_ cue: Cue) { player(for: cue)?.prepareToPlay() }

    private func player(for cue: Cue) -> AVAudioPlayer? {
        if let p = players[cue] { return p }
        let exts = ["caf", "wav", "m4a", "aif"]
        guard let url = exts.lazy.compactMap({ Bundle.main.url(forResource: cue.rawValue, withExtension: $0) }).first,
              let p = try? AVAudioPlayer(contentsOf: url) else { return nil }
        p.prepareToPlay()
        players[cue] = p
        return p
    }

    private func prepareSession() {
        guard !sessionReady else { return }
        try? AVAudioSession.sharedInstance().setCategory(.ambient, options: [.mixWithOthers])
        try? AVAudioSession.sharedInstance().setActive(true)
        sessionReady = true
    }
}
```

Usage, paired with a haptic from the same line:

```swift
Button("Send") {
    Task {
        SoundFX.shared.warm(.send)
        if await send() {
            sentCount += 1                       // .sensoryFeedback(.success, trigger: sentCount)
            SoundFX.shared.play(.send)
        }
    }
}
```

### Synthesised cue (shape only; tune the numbers to the object)

```swift
/// A short mechanical click: filtered noise (the strike) over a damped ring (the housing)
/// and a low thud (the body). Generated once per variant at launch; no assets.
static func makeClick(seed: UInt64, sampleRate sr: Double = 44_100) -> [Float] {
    var rng = SplitMix64(seed: seed)
    let duration = 0.045
    let n = Int(sr * duration)
    let resonance = 1500.0 + rng.next(in: -350...450)   // Hz; varies per variant
    let body      = 210.0  + rng.next(in: -40...40)
    let noiseDecay = 900.0 + rng.next(in: -200...300)   // 1/s
    let ringDecay  = 260.0 + rng.next(in: -60...60)
    let lpCoef = 0.35 + rng.next(in: -0.08...0.1)       // one-pole low pass on the noise
    var lp = 0.0, hpPrev = 0.0, hpPrevIn = 0.0
    var out = [Float](repeating: 0, count: n)
    for i in 0..<n {
        let t = Double(i) / sr
        lp += (rng.next(in: -1...1) - lp) * lpCoef
        let noise = lp * exp(-t * noiseDecay)
        let ring  = sin(2 * .pi * resonance * t) * exp(-t * ringDecay) * 0.35
        let thud  = sin(2 * .pi * body * t) * exp(-t * 180) * 0.25
        var s = noise * 1.6 + ring + thud
        let hp = 0.995 * (hpPrev + s - hpPrevIn); hpPrevIn = s; hpPrev = hp; s = hp   // keep it out of the mud
        let attack = min(1, t / 0.0015)                                                 // 1.5ms; no click at sample 0
        out[i] = Float(max(-1, min(1, s * attack * 0.8)))
    }
    return out
}
```

Make 6–8 variants at launch, keep a small pool of `AVAudioPlayerNode` voices, and pick a random variant per play. Throttle: `minGap = moving > 40 ? 0.018 : (moving > 8 ? 0.028 : 0)`; level `0.28 + 0.42 × min(1, moving / 60)`.

## Checks

- Play music, trigger every cue: the music never dips.
- Flip the Ring/Silent switch: every cue is silent.
- Turn the in-app toggle off: every cue is silent, including system fallbacks.
- Trigger a cue with its haptic: one event, not two.
- Headphones, each cue: no click at the start, nothing over 200ms.
- Count cues on the primary path: one to three.
- Delete a bundled file: the cue falls back to the system sound without a crash.

## Do not

- Use `.playback` or `.soloAmbient` for UI cues.
- Add a sound to tapping, typing, toggling, or scrolling.
- Ship one global volume.
- Play a sound for an error.
- Add sound to a productivity or reading app without a written reason in the design contract.
- Start a synthesised cue at full amplitude.
- Fire a sound from a timer or a background completion.
