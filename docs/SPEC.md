# Daily Vibe — Spec

This document describes what's implemented in `DailyVibe/`, and what's deliberately out of scope. iOS 17+, SwiftUI, no third-party libraries. The feature: a globally-shared daily prompt added to the existing daily notification, with an in-app surface to compare how friends interpreted it. Architecture is MVVM with `@Observable` view models, a single `PostRepository` protocol injected through `EnvironmentValues`, and a centralized `AppRouter` for navigation. Strategy and rationale live in the strategy doc; this spec is the implementation contract.

---

## 1. Surfaces & front-end behavior

Six SwiftUI surfaces. One `NavigationStack` owned by `RootRouter`; sheets are presented at the stack root.

| Surface | Type | ViewModel | State |
|---|---|---|---|
| `FeedScreen` | stack root | `FeedViewModel` | `LoadState<FeedSnapshot>` |
| `PostConfirmScreen` | push (`Route.postConfirm`) | `PostConfirmViewModel` | `LoadState<DailyPrompt>` + `isMatched: Bool` |
| `VibeView` | push (`Route.vibeView`) | `VibeViewModel` | `LoadState<VibeSnapshot>` |
| `PostDetailScreen` | push (`Route.postDetail(Post)`) | none | `let post: Post` |
| `FirstRunIntro` | sheet, medium detent | none | gated by `@AppStorage("hasSeenIntro")` |
| `SettingsScreen` | sheet, large detent | none | local `isVibeEnabled` |

The lock-screen notification is not a SwiftUI surface; it's documented in the strategy doc and shown as a static frame in the Figma prototype.

### 1.1 Navigation

```
launch → FeedScreen
       → (first launch) FirstRunIntro sheet over Feed
Feed   → tap shutter             → PostConfirm
Feed   → tap Daily Vibe strip    → VibeView
Feed   → tap profile avatar      → Settings sheet
PostConfirm → Send / Retake / ✕  → pop
VibeView    → tap grid cell      → PostDetail
PostDetail  → back chevron       → pop
```

`AppRouter` is `@Observable @MainActor`, owns `path: [Route]` and `sheet: Sheet?`, and is injected via `@Entry var router`. Screens push/pop through it; they never own a `NavigationPath` directly.

### 1.2 Per-screen behavior

**FeedScreen.** Top bar (friends icon, `BeReal.` wordmark, calendar, profile avatar). My Friends / Friends of Friends tab row (visual only). `DailyVibeStrip` with today's prompt + 4-avatar face-pile + `+N` overflow chip. `LazyVStack` of `PostCard`s. Floating shutter button over a fading bottom gradient.

**PostConfirmScreen.** Static "captured" `DualCameraPhoto`. Caption placeholder. `MatchToggleRow` bound to `vm.isMatched`; while the prompt is loading, the row's vertical space is reserved with a clear spacer so layout doesn't pop. Bottom: audience selector, centered Send button, Retake.

**VibeView.** Toolbar with stacked "today's vibe" / prompt text. Prompt card (`Vibe #N`, "N friends matched today"). 2-column `LazyVGrid` of square `DualCameraPhoto` cells with username overlay; renders `EmptyVibeState` when `matchedPosts.isEmpty`.

**PostDetailScreen.** Pure view. `DualCameraPhoto` with marker tied to `post.isVibeMatched`, `today's vibe` chip, hardcoded caption, three placeholder RealMoji circles, "0 comments". Title `\(author.username)'s BeReal.`.

**FirstRunIntro.** Yellow `VibeMarker`, headline, body copy, full-width white "Got it" button.

**SettingsScreen.** Inset-grouped dark `List`. One `Toggle` ("Show Daily Vibe prompts", default ON) + footer footnote. Toolbar Done dismisses.

### 1.3 States

Every async surface goes through `LoadState<Value>`:

```swift
enum LoadState<Value: Sendable>: Sendable {
    case idle, loading, loaded(Value), failed(RepositoryError)
}
```

`LoadStateView` renders all four:

- **idle / loading** → centered `ProgressView` (white tint).
- **loaded** → consumer-provided view builder.
- **failed** → inline error + Retry button calling `vm.refresh()`. The icon and copy are driven by the typed `RepositoryError` (`.offline` shows `wifi.slash`, others show the warning triangle).

Repositories throw a typed `RepositoryError` (`.offline`, `.timedOut`, `.server(statusCode:)`, `.decoding`, `.unknown`); `Error.asRepositoryError` bridges `URLError` / `DecodingError` from real network code. `resolveLoadState(toastCenter:errorMessage:_:)` is the canonical async wrapper: on throw it transitions to `.failed(_)` and surfaces a `ToastCenter` banner. View models never write `try/catch` directly.

**Empty** is a content state, not a `LoadState` case: `VibeView` renders `EmptyVibeState` when `loaded` but `matchedPosts.isEmpty`.

### 1.4 Animations

- **Marker reveal** (`DualCameraPhoto`): the `VibeMarker` overlay is **always rendered**; visibility is `scaleEffect` + `opacity` driven by `showMarker`, with `.animation(.spring(response: 0.4, dampingFraction: 0.65), value: showMarker)` as the last modifier. Wrapping the marker in `if showMarker { ... }` would change view identity and the spring would not animate. The marker is a sibling of the clipped photo group, not a child, so the spring overshoot bleeds outside the rounded corner.
- **Toggle**: native iOS spring, no `withAnimation` wrapper.
- **Press feedback** (`PressableButtonStyle`, scale 0.96): scoped to the shutter and Send button only — preserves the marker reveal as the singular animated moment.
- **Toast banner**: spring entry from top edge with opacity.

---

## 2. Data model

Value types in `Shared/Models/`. `Hashable` on `Post` and `Friend` is id-based (custom `==` and `hash(into:)`) so `NavigationPath.append(Route.postDetail(post))` is idempotent.

```swift
struct Friend: Identifiable, Hashable {
    let id: UUID
    let username: String        // lowercase
    let initials: String        // single uppercase char
    let avatarPaletteIndex: Int // index into AvatarPalette; domain stays free of SwiftUI types
}

struct Post: Identifiable, Hashable {
    let id: UUID
    let author: Friend
    let rearPhotoAsset: String
    let selfiePhotoAsset: String
    let timestampText: String   // pre-formatted ("now", "2h late")
    let isVibeMatched: Bool
}

struct DailyPrompt: Hashable {
    let editionNumber: Int
    let promptText: String      // lowercase
    let date: Date
    let matchedFriendsCount: Int

    func overflowCount(visibleCount: Int) -> Int {
        max(0, matchedFriendsCount - visibleCount)
    }
}

enum Route: Hashable {
    case postConfirm, vibeView, postDetail(Post)
}
```

`timestampText` is pre-formatted because the prototype's "now" is fixed; production would format relative time from a server `createdAt`.

---

## 3. API contract

The app talks to data through one protocol, injected via `@Entry`:

```swift
protocol PostRepository: Sendable {
    func feedPosts() async throws -> [Post]
    func matchedPosts() async throws -> [Post]
    func todayPrompt() async throws -> DailyPrompt
    func matchedFriendsToday() async throws -> [Friend]
}
```

Production swaps `MockPostRepository` for an HTTP client; nothing else changes.

### 3.1 Hypothetical HTTP shape

| Method | Path | Returns |
|---|---|---|
| `GET` | `/v1/feed/friends?cursor=…` | `{ posts: [PostDTO], nextCursor: String? }` |
| `GET` | `/v1/vibe/today` | `DailyPromptDTO` |
| `GET` | `/v1/vibe/today/posts` | `{ posts: [PostDTO], nextCursor: String? }` |
| `GET` | `/v1/vibe/today/friends` | `[FriendDTO]` |
| `POST` | `/v1/posts` `{ rearPhotoId, selfiePhotoId, isVibeMatched, audience }` | `PostDTO` |

`PostDTO` carries an ISO-8601 `createdAt`; the client formats relative time. `DailyPromptDTO` carries `editionNumber`, `text`, `effectiveAt` (UTC midnight), and a stable `id` for caching. Edition rotates at UTC midnight; the client displays in local time. A user crossing timezones mid-day might see edition `N → N+1` before local midnight — out of scope for V1.

### 3.2 ViewModel responsibilities

Each VM is `@Observable @MainActor final class`. Dependencies (`PostRepository`, `ToastCenter`) are captured at `init`, not passed per-call. Public API is `loadIfNeeded() async` (idempotent — no-op once `state != .idle`) + `refresh() async` (always re-fetches). No Combine subscriptions.

- `FeedViewModel` issues `feedPosts`, `todayPrompt`, `matchedFriendsToday` in parallel via `async let`, bundling into `FeedSnapshot`.
- `VibeViewModel` issues `todayPrompt` and `matchedPosts` in parallel, bundling into `VibeSnapshot`.
- `PostConfirmViewModel` fetches only `todayPrompt`. `isMatched` is local mutable state, not loaded. `publish() async -> DailyPrompt?` guards on `canPublish`, flips `isPublishing` for the duration, and returns the prompt the caller logs against.
- `PostDetailViewModel` is dependency-free: it owns `let post: Post` plus a private `appearedAt: Date?` for dwell tracking. `onAppear(now:)` records the timestamp; `onDisappear(now:) -> AnalyticsEvent?` returns the `dailyVibePostViewed` event with computed `dwellMs`.

Views construct VMs lazily inside `.task` once `@Environment` values are resolved (`@State private var vm: FeedViewModel?`). User-driven mirrors (`isMatched`, `isVibeEnabled`) are plain `var`; everything else is `private(set)`. A derived `Binding(get:set:)` for a one-bit toggle is friction with no payoff.

---

## 4. Edge cases & error handling

**Prototype scope.** The implementation is front-end-complete with a mocked `PostRepository`; the production cuts are: no real backend (no `URLSession`, no auth), no real camera (`AVFoundation`) — capture is a static composite asset, no real notifications (`UNUserNotificationCenter`) — the lock-screen surface is a Figma frame, no feed pagination, and the Settings opt-out is UI-only (does not gate the strip; see §4.5). Analytics is wired as a typed `AnalyticsLogger` protocol with a no-op default (`NoopAnalyticsLogger`) and a debug-only `ConsoleAnalyticsLogger`; no production destination is connected. The repository protocol and `LoadState` plumbing are wired so swapping in an HTTP client touches one file.

### 4.1 Load failures

Any `PostRepository` method can throw. `resolveLoadState` transitions the relevant `LoadState` to `.failed(error)` *and* calls `toastCenter.show(...)` with a screen-specific message ("Couldn't load your feed", "Couldn't load today's prompt", "Couldn't load today's vibe"). The user sees both the inline failed state with Retry and a toast. `StubFailingRepository` lets each screen render `.failed` deterministically in `#Preview`.

### 4.2 Cancellation

All async work is started from `.task { ... }`, which cancels on view dismissal. `Task.sleep` calls (used by `StubSlowRepository` to make loading visible in previews/demos) are wrapped in `do { try await ... } catch { return }` so view-pop cancellation doesn't write zombie state.

### 4.3 Empty `matchedPosts`

`VibeView` distinguishes "loaded but empty" from "loading". On `loaded` with `matchedPosts.isEmpty`, the grid is replaced with `EmptyVibeState`; the prompt card stays.

### 4.4 Face-pile overflow

`DailyVibeStrip` shows up to 4 avatars + a `+N` chip from `DailyPrompt.overflowCount(visibleCount:)`. Hidden when `matchedFriendsCount <= 4`.

### 4.5 Persistence & gating

The only persisted value is `@AppStorage("hasSeenIntro")`, flipped in `FirstRunIntro.onDisappear` so the sheet shows once per install.

The Settings `isVibeEnabled` toggle is local `@State`, not persisted, and does not gate `FeedScreen`'s strip — a deliberate prototype cut. Production would persist via `PATCH /v1/me/preferences`, mirror to a `UserSettingsStore`, and gate the strip on it. `SettingsScreen` applies `.interactiveDismissDisabled()` so the demo recording can't accidentally dismiss it mid-take.

### 4.6 Toast lifecycle

`ToastCenter` shows one toast at a time. A new `show(...)` cancels the prior auto-dismiss and replaces the current toast. Auto-dismiss after 3s; tap to dismiss immediately. `toastHost()` is attached at `RootRouter` and at each sheet so toasts surface above sheets too.

### 4.7 Navigation idempotency

`Post.Hashable` is id-based, so re-tapping a grid cell while a push is in-flight is idempotent. `pop()` always uses `path.popLast()` (no-op on empty).

### 4.8 Out of scope

Persistence beyond `hasSeenIntro`, friend graph, and feed pagination. The full prototype/production divide is summarized at the top of §4.

---

## 5. Verification

**Tests.** 20 tests across 5 suites in `DailyVibeTests/`, using Swift Testing (`Testing` framework). Run with `⌘U` or `xcodebuild test`. Strict concurrency (`SWIFT_STRICT_CONCURRENCY=complete`) is on in both Debug and Release. Coverage:

- `FeedViewModelTests` — `idle → loaded` happy path, `idle → failed` with toast surfaced, `loadIfNeeded` idempotency, `refresh` always re-fetches.
- `PostConfirmViewModelTests` — `canPublish` truth table across idle/loading/loaded/failed, `publish()` returning the loaded prompt, guarding when not loaded.
- `PostDetailViewModelTests` — dwell-ms computed from `(disappearedAt − appearedAt) × 1000`, no-appear → no event, single-shot consumption (second `onDisappear` returns nil).
- `DailyPromptTests` — `overflowCount` boundary cases (over / clamped / equal), `promptId` formatting.
- `RepositoryErrorTests` — `URLError` → `.offline` / `.timedOut` mapping, `DecodingError` → `.decoding`, typed errors pass through unchanged.

VM tests are pure-logic, driven by `RecordingPostRepository` (a configurable double recording call counts). No SwiftUI is mocked.

**Previews.** Every screen has SwiftUI `#Preview` blocks covering loaded / loading / failed states via `StubSlowRepository` and `StubFailingRepository`; `VibeView` additionally previews the empty branch.

**Manual flow:** launch → first-run sheet → Got it → Feed renders → shutter → PostConfirm → toggle (marker spring) → Send → Feed → strip → VibeView → grid cell → PostDetail → back → profile → Settings sheet → Done. All four `LoadState` transitions are reachable from previews; the failed branch is reachable in-app by injecting `StubFailingRepository` at the app root.

**Linting.** SwiftLint config at `.swiftlint.yml`; `swiftlint` runs clean (0 violations across 51 files).
