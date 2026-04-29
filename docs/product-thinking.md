# Daily Vibe — Product Thinking

A globally-shared daily prompt for BeReal's daily notification. Part 1 of the case study.

---

## 1. Strategy

Aymeric Roffé, BeReal CEO, *Campaign US*, June 2024:

> *"We are also exploring other ways to share content at different moments of the day more proactively."*

**The proposal: Daily Vibe.** A single line added to the daily BeReal notification — *"Today's vibe: your hands"* — same prompt for every user globally that day. Posts that match the prompt carry a small ✦ marker. Default off, opt-in per post. No streaks, points, or leaderboards.

That's the whole feature.

**Why now.** BeReal's notification is doing only half of its job. It's a trigger, not a creative cue. Users get pushed, post a desk pic, leave. Sensor Tower's May 2024 read: time-spent down 6%, sessions down 14%, despite ~70% of users still posting daily. The failure mode isn't acquisition — it's that a daily ritual without content variety asymptotes. BeReal hit break-even in May 2025 and stabilized at 30M MAU. The window for retention investment is open.

Daily Vibe gives the notification something to say. *"Today's vibe: your hands"* answers "what should I post" for the user who's drawing a blank, and creates a comparison loop for the user who's already engaged: *what did everyone else do with the same theme?* That's the second reason to open the feed, which is the thing the product is missing.

**The bet.** Wordle and Wrapped both worked because they had viral byproducts — emoji grids on Twitter, Wrapped slides on Stories. Daily Vibe doesn't. The bet is that the in-app comparison surface — a strip at the top of the feed showing how friends interpreted today's prompt — substitutes for that share loop. If it doesn't, the feature fails. The A/B test below is designed to test exactly this.

**The risk that scares me.** This feature lives or dies on prompt quality, and prompt quality is an editorial problem, not an engineering one. *"Show us your weekend"* is a feature-killing prompt. *"The mess you ignored"* is a feature-making one. Engineering can't fix this gap. Before we ship, I'd want a named editorial owner with a 90-day prompt backlog signed off by leadership. If we can't staff that role, the feature shouldn't ship.

**Alternatives I considered and dropped.**

The strongest one was a Locket-style home-screen widget. Real precedent (Locket's 9M DAU), clear retention mechanic. I dropped it because it solves the wrong problem: a widget surfaces *what your friends did*; Daily Vibe surfaces *how your friends thought*. The retention I want is from comparison, not glance. A widget also fights with shipped WidgetMojis and pulls BeReal toward ambient consumption, which Moore explicitly disowns ("we don't want users scrolling endlessly").

Close Friends audience filter was tempting but only helps users with bloated friend lists — a real segment, but not the whole user base. Throwbacks needs 30+ days of history to work, so it cold-starts broken for new users. A streak/quest gamification layer was the most fun to design and the most obviously brand-violating; it would've turned the daily moment into pressure.

Daily Vibe is the one option that works for users with 5 friends or 50, with one day of history or one year, and doesn't require BeReal to start scrolling.

**Expected lift.** +0.5pp to +1pp absolute on D7 over a 14–28 day window. Above that range in a mature social app is novelty inflation; below it doesn't justify the surface area. I'm not setting a stretch case — the conservative band is the right one to plan against, and Voodoo's own retention bar (45% D1, 13% D7 for greenlit games) is calibrated the same way.

**Rollout.** Soft-launch in two non-strategic markets (need ≥500K DAU each, <10% revenue share each — final pick depends on the dashboard). 50/50 A/B for 14 days. Ship if D7 lifts ≥0.5pp with no guardrail breach. Kill if D7 goes negative or notification opt-out climbs more than 2pp. Running 14 days, not 28, on purpose: I'd rather kill the feature on weaker data than let novelty buy it a false win.

---

## 2. User Journey

**The retention moment isn't the post. It's the comparison.**

First-run is handled in the existing onboarding flow — one card explaining the new line on the notification, dismissable. Spec covers the details.

Steady state, daily:

1. **2:47 PM.** Phone buzzes. *"⚠️ Time to BeReal. ⚠️ — Today's vibe: your hands."* One extra line. That's the only new thing on the lock screen.
2. **Camera opens.** Small chip at the top: *"✦ Today's vibe: your hands."* Doesn't gate the camera. User can ignore it entirely.
3. **Capture.** Same dual-camera flow as today. Nothing changed.
4. **Post-confirm.** A subtle toggle below the photo: *"Match today's vibe?"* Default off. Yes adds the ✦ marker; no posts a normal BeReal. Self-declared, no algorithm. Default off is intentional — every match is intentional, which is what we want to measure.
5. **Publish.** Post goes up. If marked, it carries a small ✦ in the bottom-right corner of the card — a sparkle, ~12pt, low-contrast. Visible to friends without dominating the post.
6. **Friends receive it.** Same fan-out as a normal BeReal. No special channel, no second push.
7. **Feed (later).** Thin horizontal strip at the top: *"Today's vibe: your hands"* with a row of avatars — friends who matched.
8. **Vibe view.** Tap the strip → matched posts only, larger cards, recency-sorted. Same RealMojis, same comments.
9. **The loop.** Marco's typing hands. Aigerim's hands holding tea. Mom's gardening hands. Two RealMojis sent. App closed. ~90 seconds.
10. **Tomorrow.** New prompt. Same loop, new lens.

Failure paths I'm watching: users who don't match should feel zero pressure; the strip lives at the top of the feed, ignorable, and "no match" is the default. New users with <3 friends see a near-empty vibe view, so the strip should hide rather than render emptiness. Cross-border friend-graph spillover means a control user might still see vibe-marked posts from treatment friends — handled in the A/B section. English-language prompts won't work cleanly in all markets; V1 launches English-only, V2 localizes.

---

## 3. Metrics

| | Metric | What "good" looks like |
|---|---|---|
| Primary | **D7 retention.** Users responding to a BeReal notification on Day 0 who also respond on Day 7. Calendar-day, classic. | +0.5pp to +1pp absolute vs. control over 14–28 days |
| Secondary | **Sessions per DAU per day.** | +0.3 to +0.5 incremental sessions |
| Adoption | **Vibe match rate.** Share of all posts that opt into the marker. | ≥15% in week 1, ≥25% by week 4 |
| Guardrail | **Notification opt-out rate.** Users disabling BeReal pushes during the test. | Must not climb >2pp absolute |

The primary measures retention. The secondary tests the load-bearing assumption — if the comparison surface drives second sessions, this metric moves; if it doesn't, the whole thesis fails. The adoption metric is the diagnostic — if D7 doesn't move, vibe match rate tells us whether we have a quality problem (low adoption) or a mechanism problem (high adoption, no retention). The guardrail protects the host: the notification *is* BeReal — damaging it kills everything.

**Honest tension.** If D7 lifts but sessions/DAU stays flat, the primary metric is winning without the mechanism actually working. That's a Goodhart problem — we'd be retaining users for some unrelated reason (novelty, push reactivation, opt-in selection bias) and calling it a win. The case I'd argue against the team: don't ship a win we don't understand.

**What's not the primary metric.** DAU. DAU is gameable through notification optimization and Goodhart-prone for an authenticity product. The North Star is closer to *daily connected friends* — users who both post and react that day. Daily Vibe ladders to that, not to raw DAU. And the feature should never be evaluated in a way that lets it become the engagement trap it was designed to avoid.

---

## 4. Tracking Plan

snake_case, Object-Action, past tense. Global super-properties on every event: `user_id`, `session_id`, `app_version`, `os`, `locale`, `country`, `experiment_daily_vibe_variant`, `friend_count_bucket`.

| # | Event | When it fires | Properties |
|---|---|---|---|
| 1 | `daily_vibe_notification_opened` | User taps the push | `prompt_id`, `time_to_open_seconds` |
| 2 | `daily_vibe_match_toggled` | User flips the match toggle on post-confirm | `prompt_id`, `match_value`, `toggle_count` |
| 3 | `daily_vibe_post_published` | Post sent | `prompt_id`, `post_id`, `is_vibe_match`, `is_within_window`, `is_late_post` |
| 4 | `daily_vibe_strip_tapped` | User taps the feed-top strip | `prompt_id`, `friends_matched_count_visible` |
| 5 | `daily_vibe_post_viewed` | Friend or self views a matched post | `post_id`, `viewer_relationship`, `dwell_ms`, `surface` |
| 6 | `daily_vibe_reaction_sent` | RealMoji or comment on a matched post | `post_id`, `reaction_type`, `is_first_reaction`, `surface` |
| 7 | `bereal_notification_disabled` *(existing, monitored as guardrail)* | User disables push | `last_post_days_ago`, `experiment_variant` |

What I deliberately don't track: any event that requires the user to declare why they matched or didn't. Self-declaration is the entire mechanic — adding a "why" field destroys the playfulness.

---

## 5. A/B Test

**Hypothesis.** Adding a globally-shared daily theme to the BeReal notification will lift D7 retention by +0.5pp absolute, by giving users a second daily reason to open the feed (cross-friend comparison), without harming notification opt-out rate.

**Setup.** 50/50, control vs. treatment.

**Cluster randomization.** Country-level, not user-level. The prompt creates friend-graph spillover — a control user with treatment friends would see vibe-marked posts in their feed, contaminating the control. SUTVA assumption broken. Country-level clusters fix it.

**Market choice.** Three signals from the data team: per-country DAU (need ≥500K for power), per-country revenue share (need <10% to limit blast radius), friend-graph density (lower = less cross-border contamination). My prior is Spain or Italy in EU, Japan or Korea in APAC. I'd defer to the dashboard.

**Sample size.** With 30M MAU and a ~30% D7 baseline, detecting +1pp absolute lift at 80% power needs ~34,000 users per arm. Solved in under a day. The binding constraint is calendar time, not sample size.

**Duration.** 14 days minimum — one full weekly cycle, novelty mostly decayed by day 8. 21–28 days preferred to capture multiple D7 cohorts. Frozen analysis plan committed before launch.

### Decision rules

| Outcome | Action |
|---|---|
| D7 lifts ≥0.5pp absolute, p<0.05, no guardrail breach | Ship. 5% → 25% → 100% over 2 weeks. |
| D7 lifts but <0.5pp, no guardrail breach | One follow-up test on prompt-voice variants. |
| D7 null, no guardrail breach | Re-examine prompt quality. One more 14-day test, then kill. |
| D7 negative, OR opt-out up >2pp, OR report rate up materially | Kill. |

### What I'd kill on, explicitly

- Notification opt-out climbs >2pp absolute. The notification is BeReal. Damage it and you damage the host.
- Sessions per DAU drop while D7 lifts. Means we're retaining shallow users at the cost of engaged ones. A bad trade.
- Vibe match rate stays under 10% in week 2. The comparison surface is too sparse to support the thesis.
- Editorial check at week 2: if the prompts read as cringe, the bar is unsalvageable. Kill instead of iterating.
