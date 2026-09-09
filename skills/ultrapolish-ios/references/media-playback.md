# Video and audio playback

Use this when the app plays something: a clip, a podcast, a lesson, a voice note, a user's recording. Sound design for interface feedback is in `references/sound.md`; this is content playback.

Playback is where an app stops being alone on the device. It shares the audio session, the Lock Screen, the Control Centre, CarPlay, headphone buttons and the car stereo, and doing that badly is far more visible than any pixel.

## Rules

1. **Declare the audio session for what the app actually is.** `.playback` for content the user chose to hear, which keeps playing when the screen locks and correctly interrupts their music. `.ambient` with `.mixWithOthers` for interface sound that should never stop a podcast. Getting this backwards is why an app cuts someone's music to play a two-second effect. Check: start a podcast, open the app, and confirm the right thing happened.
2. **Fill in Now Playing or the Lock Screen is blank.** `MPNowPlayingInfoCenter` with the title, the artist or source, the artwork, the duration and the current time, updated as playback moves. Without it the Lock Screen shows nothing and the car stereo shows nothing, and the app looks broken in the place people most often look. Check: lock the phone mid-playback and look at the screen.
3. **Wire the remote commands, all of the ones you claim.** `MPRemoteCommandCenter` for play, pause, toggle, skip forward and back with real intervals, and next and previous only if those mean something. Disable the ones that do not apply rather than leaving them enabled and inert; a headphone button that does nothing is worse than one that is greyed out. Check: control playback entirely from the Lock Screen and from headphone buttons.
4. **Handle interruptions and route changes, because both will happen.** A phone call interrupts; on `.ended` with `.shouldResume`, resume, and otherwise stay paused. Unplugging headphones delivers `.oldDeviceUnavailable` and the app must pause, never continue out loud into a quiet room. Check: unplug headphones mid-playback; it pauses.
5. **Scrubbing follows the finger linearly and previews where it will land.** No spring, no easing, no animation on the thumb while a finger is on it. Show the timestamp during the drag, and on video a frame preview if you can generate one. Fire a `.selection` haptic on chapter or marker crossings, not per pixel. Check: scrub slowly; the thumb tracks exactly and the time updates continuously.
6. **Time is monospaced and does not reflow.** `.monospacedDigit()` on elapsed and remaining, with a width reserved for the longest value the content can reach, so 9:59 becoming 10:00 does not shift the scrubber. Check: watch across a rollover from single to double digits.
7. **Buffering and paused are different states and must look different.** A spinner over the transport while stalled, with the play or pause state itself unchanged underneath. An app that shows a play triangle while it is really buffering teaches people to tap twice and skip. Check: throttle the network mid-playback.
8. **Video is `AVPlayerViewController` unless there is a reason.** It brings picture-in-picture, AirPlay, subtitles, audio track selection, the skip gestures and full-screen behaviour, all of which you would otherwise owe. A custom transport means rebuilding every one. Check: with a custom player, verify PiP, AirPlay and subtitle selection all still exist.
9. **Captions and audio descriptions are shipped and respected.** Honour `.isClosedCaptioningEnabled` and the system's preferred languages, and default captions on for speech-led content. Most viewing in public happens with the sound off. Check: enable captions system-wide and confirm they appear without being asked for.
10. **Background playback is a capability you either have or do not.** If audio should continue with the screen locked, enable the background mode, keep the session active, and keep Now Playing current. Half-implementing it, where audio continues but the Lock Screen is empty and the remote commands are dead, is worse than not supporting it. Check: lock the screen and control playback without unlocking.
11. **A waveform is either real or absent.** A decorative waveform that does not match the audio misleads someone using it to navigate. If you cannot compute one, show a plain progress bar. Check: compare a loud passage against the drawing.
12. **Remember the position for anything long, per item.** Resume where they left off, say that you are doing it, and offer starting over. Check: leave halfway, return tomorrow.
13. **One thing plays at a time inside the app.** Starting a second item stops the first, always. Check: start another and confirm the first stops rather than mixing.
14. **Reserve the video's aspect ratio before it loads.** Otherwise the layout jumps when the first frame arrives. A poster or a placeholder at the correct ratio, then the player. Check: load on a throttled connection; nothing moves.

## Cheat sheet

| Thing | Value |
|---|---|
| Content playback | `.playback`; keeps playing when locked, interrupts other audio |
| Interface sound | `.ambient` + `.mixWithOthers`; never stops their music |
| Lock Screen | `MPNowPlayingInfoCenter`, kept current, with artwork |
| Remote commands | Enable only what works; disable the rest explicitly |
| Headphones unplugged | `.oldDeviceUnavailable` means pause |
| Call ended | `.shouldResume` means resume, otherwise stay paused |
| Scrubbing | Linear, follows the finger, `.selection` on markers only |
| Time labels | `.monospacedDigit()` with a reserved width |
| Video | `AVPlayerViewController` unless you will rebuild PiP, AirPlay and subtitles |
| Captions | Default on for speech-led content; honour the system setting |

## Code

```swift
// The session declares what the app is. Getting this wrong is why apps
// stop someone's podcast to play a click.
try AVAudioSession.sharedInstance().setCategory(.playback, mode: .spokenAudio)
try AVAudioSession.sharedInstance().setActive(true)

// Without this the Lock Screen and the car stereo are blank.
MPNowPlayingInfoCenter.default().nowPlayingInfo = [
    MPMediaItemPropertyTitle: episode.title,
    MPMediaItemPropertyArtist: show.name,
    MPMediaItemPropertyPlaybackDuration: episode.duration,
    MPNowPlayingInfoPropertyElapsedPlaybackTime: player.currentTime().seconds,
    MPNowPlayingInfoPropertyPlaybackRate: player.rate,
]

// Headphones out means pause, not "keep playing out loud on the train".
NotificationCenter.default.addObserver(
    forName: AVAudioSession.routeChangeNotification, object: nil, queue: .main
) { note in
    guard
        let raw = note.userInfo?[AVAudioSessionRouteChangeReasonKey] as? UInt,
        AVAudioSession.RouteChangeReason(rawValue: raw) == .oldDeviceUnavailable
    else { return }
    player.pause()
}
```

## Checks

- Start a podcast, then open the app: the right thing happens to their audio.
- Lock the phone mid-playback: title, artwork and progress are on the Lock Screen.
- Control playback from the Lock Screen and from headphone buttons.
- Unplug headphones mid-playback: it pauses.
- Take a call and end it: it resumes only if the system said to.
- Scrub slowly: the thumb tracks the finger exactly and the time is continuous.
- Watch a rollover from 9:59 to 10:00: nothing shifts.
- Throttle mid-playback: buffering does not look like paused.
- Turn on system captions: they appear without being asked for.
- Load a video on a slow connection: the box is reserved.

## Do not

- Use `.playback` for a tap sound, or `.ambient` for content.
- Ship playback with an empty Lock Screen.
- Leave remote commands enabled but inert.
- Keep playing when the headphones come out.
- Animate the scrubber thumb while a finger is on it.
- Let a buffering player look paused.
- Rebuild a video transport without PiP, AirPlay and subtitles.
- Draw a waveform that is not the audio.
