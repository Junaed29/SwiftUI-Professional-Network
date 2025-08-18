// filepath: ProfessionalNetworkingApp/Shared/Components/LottieView.swift
// LottieView.swift
// ProfessionalNetworkingApp
/*
 # LottieView

 A reusable, efficient SwiftUI wrapper for [Lottie](https://github.com/airbnb/lottie-spm) animations.

 - Reuses a single `AnimationView` under the hood for performance
 - Configurable loop mode, speed, contentMode, and optional segment range
 - Autoplay behavior is opt-in/out

 ## Installation
 1) Add Lottie via Swift Package Manager:
 - Xcode → File → Add Packages… → https://github.com/airbnb/lottie-spm → Add to your app target
 2) Place your `.json` animation files in the app bundle (e.g., drag into Xcode and “Copy items if needed”).

 ## API
 ```
 LottieView(
 filename: String,                    // animation file name without .json
 bundle: Bundle = .main,              // where to load from
 loopMode: LottieLoopMode = .loop,    // .loop | .playOnce | .repeat(n)
 autoplay: Bool = true,               // auto-start playback
 speed: CGFloat = 1.0,                // playback speed multiplier
 contentMode: UIView.ContentMode = .scaleAspectFit,  // scaling mode
 playRange: ClosedRange<CGFloat>? = nil              // optional [0,1] progress segment
 )
 ```

 ### Parameters
 - filename: Name of the animation file in the bundle without the `.json` extension (e.g., "onboarding-relax" → "onboarding-relax.json").
 - bundle: The bundle that contains the animation; defaults to `.main`.
 - loopMode: Controls looping behavior. Use `.loop` to loop forever, `.playOnce` to play once, or `.repeat(n)` to play `n` times.
 - autoplay: If `true`, starts playback automatically when the view appears.
 - speed: Playback speed multiplier. `1.0` is normal, `2.0` is 2x.
 - contentMode: How the animation fits in the available space. Common: `.scaleAspectFit` or `.scaleAspectFill`.
 - playRange: Optional normalized progress range `[0, 1]` to play just a segment of the animation.

 ## Usage examples
 ```swift
 // Full animation, loops forever
 LottieView(filename: "onboarding-relax")
 .frame(height: 300)

 // Play once at 1.5x speed
 LottieView(filename: "onboarding-relax", loopMode: .playOnce, speed: 1.5)
 .frame(height: 240)

 // Play a segment (20% to 80%), no autoplay
 LottieView(filename: "onboarding-relax", autoplay: false, playRange: 0.2...0.8)
 .frame(height: 240)
 ```

 ### In OnboardingStepView
 ```swift
 struct OnboardingStepView: View {
 var data: OnboardingDataModel
 var body: some View {
 VStack {
 LottieView(filename: data.image) // data.image should match a .json filename without extension
 .frame(height: 300)
 // ... your text, buttons, etc.
 }
 .padding()
 }
 }
 ```

 ## Notes & Tips
 - Ensure the JSON filenames match exactly (case-sensitive) and are included in your app target.
 - If nothing plays, check that the file exists in the bundle, and the filename passed does not include `.json`.
 - Prefer `.scaleAspectFit` to show the entire animation without cropping; use `.scaleAspectFill` if you want to cover.
 - For long-running animations, consider `.loop` or `.repeat(n)` to avoid unexpected stops.

 ## Troubleshooting
 - Build fails with "No such module 'Lottie'": Make sure the SPM package was added to the correct target.
 - Animation doesn’t appear: Verify the JSON is copied into the bundle (Build Phases → Copy Bundle Resources) and the filename matches.
 - Performance: Keep the view lightweight; avoid stacking many Lottie animations on the same screen. The wrapper reuses `AnimationView` to reduce overhead.
 */

//
// A reusable, efficient SwiftUI wrapper for Lottie animations (Lottie 4.3+).
// - Uses Lottie's native SwiftUI LottieView for declarative playback
// - Configurable loop mode, speed, contentMode, and optional play range
// - Avoids imperative calls by mapping to .playing/.looping/.currentProgress
//
// Usage (examples):
//   // Full animation, loops forever
//   LottieView(filename: "onboarding-relax")
//
//   // Play once at 1.5x speed
//   LottieView(filename: "onboarding-relax", loopMode: .playOnce, speed: 1.5)
//
//   // Play a segment (20% to 80%), no autoplay
//   LottieView(filename: "onboarding-relax", autoplay: false, playRange: 0.2...0.8)
//
// Notes:
// - Add Lottie via SPM: https://github.com/airbnb/lottie-spm
// - Place your .json in the app bundle; pass the filename without the .json extension.

import SwiftUI
import Lottie

/// A SwiftUI view that plays a Lottie JSON animation from your app bundle.
///
/// Features
/// - Reuses a single underlying `Lottie.LottieView` for performance and API parity
/// - Supports loop modes, playback speed, content mode, and segment ranges
/// - Autoplay or manual playback patterns via declarative modifiers
struct LottieView: View {
    // MARK: - Inputs
    /// The animation file name (without the .json extension) in the specified bundle.
    var filename: String
    /// The bundle to load the animation from. Defaults to `.main`.
    var bundle: Bundle = .main
    /// The looping behavior for the animation. Defaults to `.loop`.
    var loopMode: LottieLoopMode = .loop
    /// Whether the animation should automatically start playing. Defaults to `true`.
    var autoplay: Bool = true
    /// Playback speed multiplier. Defaults to `1.0`.
    var speed: CGFloat = 1.0
    /// How the animation content is scaled within its container. Defaults to `.scaleAspectFit`.
    var contentMode: UIView.ContentMode = .scaleAspectFit
    /// Optional normalized progress range [0, 1] to play. If `nil`, plays the full animation.
    var playRange: ClosedRange<CGFloat>? = nil

    // MARK: - Init (documented)
    /// Creates a LottieView.
    /// - Parameters:
    ///   - filename: Animation file name (without .json extension) in `bundle`.
    ///   - bundle: Bundle to load animation from. Default: `.main`.
    ///   - loopMode: Loop behavior. Default: `.loop`.
    ///   - autoplay: Start automatically. Default: `true`.
    ///   - speed: Playback speed multiplier. Default: `1.0`.
    ///   - contentMode: Content scaling mode. Default: `.scaleAspectFit`.
    ///   - playRange: Optional progress range in [0, 1]. Default: `nil` (full).
    init(
        filename: String,
        bundle: Bundle = .main,
        loopMode: LottieLoopMode = .loop,
        autoplay: Bool = true,
        speed: CGFloat = 1.0,
        contentMode: UIView.ContentMode = .scaleAspectFit,
        playRange: ClosedRange<CGFloat>? = nil
    ) {
        self.filename = filename
        self.bundle = bundle
        self.loopMode = loopMode
        self.autoplay = autoplay
        self.speed = speed
        self.contentMode = contentMode
        self.playRange = playRange
    }

    var body: some View {
        var view = Lottie.LottieView(animation: .named(filename, bundle: bundle))
            .configure { lottieAnimationView in
                lottieAnimationView.contentMode = contentMode
                lottieAnimationView.animationSpeed = speed
            }

        // Apply playback behavior
        if autoplay {
            if let range = playRange {
                view = view.playing(.fromProgress(max(0, min(1, range.lowerBound)),
                                                  toProgress: max(0, min(1, range.upperBound)),
                                                  loopMode: loopMode))
            } else {
                switch loopMode {
                case .loop:
                    view = view.looping()
                case .playOnce:
                    view = view.playing()
                case .repeat(_):
                    // Use playing with explicit range and loopMode to respect repeat counts
                    view = view.playing(.fromProgress(0, toProgress: 1, loopMode: loopMode))
                case .autoReverse:
                    // Auto-reverse between start and end indefinitely
                    view = view.playing(.fromProgress(0, toProgress: 1, loopMode: loopMode))
                case .repeatBackwards(_):
                    // Repeat while reversing direction after each loop
                    view = view.playing(.fromProgress(0, toProgress: 1, loopMode: loopMode))
                @unknown default:
                    view = view.playing()
                }
            }
        } else {
            // Not autoplay: display at initial progress (or start of range)
            view = view.currentProgress(playRange?.lowerBound ?? 0)
        }

        return view
    }
}
