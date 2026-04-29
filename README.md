
# Daily Vibe

A feature concept for a daily-photo social app: a globally-shared daily prompt added to the existing daily notification, with an in-app surface to compare how friends interpreted it.

Built as a 4-day take-home for a Founding/Product Engineer role.

<div align="center">
  <video src="https://github.com/user-attachments/assets/00b409e0-bf19-4861-a25e-52cc904cb0c0" controls></video>
</div>


## Feature in one screen

The notification adds a single line: *"Today's vibe: your hands."* On post-confirm, a new toggle defaults OFF — flipping it adds a small ✦ marker to the post. A new strip at the top of the feed shows how friends interpreted today's prompt, opening a dedicated grid view of matched posts. No streaks, no leaderboards, no algorithmic judgment.

## What's interesting in the code

- **MVVM with `@Observable`** view models, no Combine subscriptions. Strict concurrency on in Debug + Release.
- **One `PostRepository` protocol** injected through `EnvironmentValues` — swapping `MockPostRepository` for an HTTP client touches one file.
- **Typed `RepositoryError`** drives both the failed-state UI (icon, copy) and toast banners; `URLError` and `DecodingError` are bridged at the boundary.
- **`LoadState<Value>`** as the spine of every async screen — idle, loading, loaded, failed — with a single `LoadStateView` rendering all four. Empty is a content state, not a load state.
- **20 tests across 5 suites** in Swift Testing. View models tested as pure logic via `RecordingPostRepository` doubles — no SwiftUI mocked.

## What's deliberately out of scope

No real camera (`AVFoundation`), no real notifications (`UNUserNotificationCenter`), no backend, no third-party libraries, no friend graph, no feed pagination. The repository protocol and `LoadState` plumbing are wired so production cuts are localized.

## Run

```bash
open DailyVibe.xcodeproj
```

⌘R to run, ⌘U to test. iOS 17+, Xcode 26.4, no third-party dependencies.

```bash
xcodebuild test -project DailyVibe.xcodeproj -scheme DailyVibe \
  -destination 'platform=iOS Simulator,name=iPhone 17'
```

## Layout

```
DailyVibe/
├── App/         @main, router, environment install
├── Features/    one folder per screen (VM + View paired)
└── Shared/
    ├── Analytics/   typed events, logger protocol
    ├── Components/  reusable views
    ├── Data/        PostRepository protocol + impls
    ├── Models/      domain types, LoadState
    └── Theme/       colors, typography
```

Feature-organized: each screen owns its View + ViewModel in one folder. Shared lives in `Shared/`, with the rule that a component moves there only when a second feature needs it.

## Lint

```bash
swiftlint            # report
swiftlint --fix      # auto-fix
```

Config in `.swiftlint.yml`; runs clean (0 violations across 51 files).
