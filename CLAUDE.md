# ProfessionalNetworkingApp — Project Guide

SwiftUI prototype of a Tinder-style professional networking app. Currently a UI/UX prototype running on mock data; backend integration (Firebase) is stubbed but not wired up.

## Stack

- **SwiftUI** (iOS 17.6+ deployment target, Swift 5)
- **@Observable** macro for state (modern, no Combine)
- **NavigationStack** for path-based routing
- **Lottie** (airbnb/lottie-ios, v4.5.2+) — only third-party dependency, via SPM
- **No Firebase SDK yet** — `FirebaseConstants.swift` holds placeholder strings; `FirebaseManager.swift` is an empty singleton. All "services" return mock data with artificial delays.

## Top-level layout

```
ProfessionalNetworkingApp/
├── App/                   # Entry point + AppRoot flow coordinator
├── Core/                  # Feature modules (MVVM: Models / ViewModels / Views)
│   ├── Authentication/    # Phone+OTP, OAuth, Welcome
│   ├── Chat/              # Conversations list + thread
│   ├── Discovery/         # Tinder-style swipe deck
│   ├── Notification/      # Notifications list
│   ├── Onboarding/        # Lottie-driven first-run flow
│   ├── Profile/           # View/edit profile
│   └── Shell/             # MainTabView (4 tabs)
├── Services/
│   ├── API/               # Protocol-first service stubs (AuthService, ChatService, ...)
│   ├── Managers/          # AuthenticationManager, DatabaseManager, etc. (mock)
│   ├── Repositories/      # Profile/User/Match repositories (thin wrappers)
│   └── Routing/           # Route enum, Router, NavigationContainer
├── Shared/
│   ├── AppState/          # Global flow state (onboarding→auth→main), UserDefaults-backed
│   ├── Components/        # 15+ reusable SwiftUI views (ChipView, ImageLoader, LottieView, ...)
│   ├── Theme/             # AppTheme palette (light/dark), Typography, ButtonStyles
│   ├── Extensions/        # Color+hex, View+modifiers, String helpers
│   ├── Utilities/         # ImagePicker, LocationManager, ValidationHelper
│   └── Constants/         # AppConstants, FirebaseConstants (stubbed)
└── Resources/             # Assets.xcassets + Lottie JSON animations
```

## Architecture

### MVVM

Every feature folder holds `Models/`, `ViewModels/`, `Views/`. Newer ViewModels use `@Observable`; older ones use `ObservableObject` + `@Published` (e.g. `DiscoveryViewModel`). ViewModels own business logic and call Services; Views observe state via `@State`/`@ObservedObject` and render.

### Flow coordination — [AppState.swift](ProfessionalNetworkingApp/Shared/AppState/AppState.swift)

Single `@Observable` source of truth with two persisted booleans (`hasCompletedOnboarding`, `isAuthenticated`) written through to `UserDefaults`. `currentFlow` is a computed `Flow` enum (`.onboarding | .auth | .main`). [AppRoot.swift](ProfessionalNetworkingApp/App/AppRoot.swift) switches on `currentFlow` and uses `.id(appState.currentFlow)` to force a fresh `NavigationContainer` when the flow changes (so the nav stack resets).

### Routing — [Services/Routing/](ProfessionalNetworkingApp/Services/Routing/)

Type-safe, enum-based path routing (NOT URL/deep-link based):

- [Route.swift](ProfessionalNetworkingApp/Services/Routing/Route.swift) — all destinations as a `Hashable` enum (`.welcome`, `.phoneLogin`, `.otpVerification(phone:)`, `.mainTabBar`, ...)
- [Router.swift](ProfessionalNetworkingApp/Services/Routing/Router.swift) — `@Observable` stack wrapper; `push`, `pop`, `popTo(depth:)`, `popToRoot`, `setStack`
- [NavigationContainer.swift](ProfessionalNetworkingApp/Services/Routing/NavigationContainer.swift) — `NavigationStack` + single `navigationDestination(for: Route.self)` switch that maps each case → destination view
- [RouterEnvironment.swift](ProfessionalNetworkingApp/Services/Routing/RouterEnvironment.swift) — `@Environment(\.appRouter)` accessor + `.provideRouter(router)` modifier

Push a new screen from anywhere with `router.push(.profile(userID:))`.

### Theming — [Shared/Theme/AppTheme.swift](ProfessionalNetworkingApp/Shared/Theme/AppTheme.swift)

Design tokens (palette, spacing, radius, motion) are defined as `enum AppTheme` namespaces. Two hand-tuned palettes (`light` / `dark`) exposed via `@Environment(\.appPalette)`. Apply the theme with the `.appTheme()` modifier (set once in `AppRoot`); the palette auto-resolves from `@Environment(\.colorScheme)`.

### Services (currently mocked)

- **AuthService** → `AuthenticationManager` — simulates OTP send/verify with `DispatchQueue` delays.
- **ProfileService** → `DatabaseManager` — returns a stub `UserProfile`, accepts saves with a no-op success.
- **ChatService / DiscoveryService** — protocol stubs, no implementations.
- **Repositories** (`ProfileRepository`, `UserRepository`, `MatchRepository`) — thin adapters over Services. Expected to be the seam where Firebase/REST gets wired in.

Mock data lives with the models — notably [UserProfile.swift](ProfessionalNetworkingApp/Core/Profile/Models/UserProfile.swift) exposes `MockProfiles.sample` (7 diverse profiles) and `myMockedProfile()` for "current user" (hardcoded as Junaed Muhammad Chowdhury).

## Conventions

- **Feature isolation**: never reach across feature folders from a View. Go through a Service/Repository, or route via `Router`.
- **Mock-first**: new features land with mock data in the Service layer before any backend is considered.
- **Environment injection**: shared dependencies (AppState, Router, palette) travel via SwiftUI `@Environment`, not singletons.
- **`@Observable` for new ViewModels**; leave existing `ObservableObject` ones alone unless touching them for another reason.
- **Design tokens, not raw values**: use `palette.primary`, `AppTheme.Radius.lg`, etc. — don't hard-code hex or CGFloat literals in Views.

## Entitlements — [ProfessionalNetworkingApp.entitlements](ProfessionalNetworkingApp/ProfessionalNetworkingApp.entitlements)

App Sandbox on, read-only access to user-selected files. No camera/mic/contacts entitlements yet.

## Build & run

Open [ProfessionalNetworkingApp.xcodeproj](ProfessionalNetworkingApp.xcodeproj/) in Xcode 16+. SPM resolves Lottie on first build. Target iOS 17.6+ simulator or device. No secrets or config files required — the Firebase constants are still placeholders.

## Known gaps (roadmap)

1. Wire up Firebase Auth (phone + OAuth) through `AuthenticationManager`.
2. Firestore-back the `ProfileRepository`, `MatchRepository`, and chat services.
3. Cloud Storage for avatar uploads (currently just URLs).
4. Push notifications for matches/messages.
5. Actual chat send/receive (currently mock conversations only).
