# Social Feature (`lib/features/social/`)

## Purpose
Manages privacy-first Squads, Squad Readiness Board (tiers only), Activity Feed (`/feed`), Squad Challenges, and Leaderboards with anonymity controls.

## Subdirectories
- **`models/`**: `SquadMember`, `ActivityFeedItem`, and `LeaderboardEntry` data models.
- **`providers/`**: Riverpod state management for active squad feeds, high-fives, and anonymity toggles.
- **`screens/`**: Interactive `ActivityFeedScreen` for social activity updates and squad boards.
