# Social & Sangha Hub (`lib/features/social`)

## Overview
The **Social & Sangha Hub** is FitKarma's cultural community operating system. It moves beyond superficial social networks by creating tight, highly accountable micro-squads (3–5 people), Indian joint-family vitals monitoring, neighborhood clubs, and privacy-first activity feeds.

---

## Core Engines & Components

### 1. `SquadAccountabilityEngine`
- **Location**: `lib/features/social/domain/services/squad_accountability_engine.dart`
- **Responsibilities**:
  - Computes squad daily adherence percentage.
  - Multiplier tiers based on streak length:
    - 3 days: 1.10x
    - 7 days: 1.20x
    - 14 days: 1.35x
    - 30 days: 1.50x
  - Generates culturally empathetic morning/afternoon/evening accountability nudges with bilingual English/Hindi phrasing.

### 2. `FamilyHealthMonitoringEngine`
- **Location**: `lib/features/social/domain/services/family_health_monitoring_engine.dart`
- **Joint Family Health**:
  - Remote monitoring for elderly parents and grandparents.
  - Categorizes Blood Pressure and Fasting Glucose into `HealthAlertLevel` (normal, attentionNeeded, urgentConsultation).
  - Cultural blessing reactions: *Pranam (सादर प्रणाम)*, *Ashirwad (आशीर्वाद)*, and *Chai Cheer*.

### 3. `LeaderboardRankingEngine`
- **Location**: `lib/features/social/domain/services/leaderboard_ranking_engine.dart`
- **Rankings & Badges**:
  - Ranks individuals and squads by total Karma points and streak days.
  - Awards dynamic badges: `👑 Golden Yogi (#1)`, `⚡ Podium Elite (Top 3)`, `🔥 Top 10 Champion`.

### 4. `SocialRepository`
- **Location**: `lib/features/social/data/social_repository.dart`
- **Drift Tables**:
  - `LocalSquads` & `LocalSquadMembers`
  - `LocalCommunityPosts`
  - `LocalFamilyMembers`
  - `LocalClubs`
- **Outbox Sync**: Queues offline mutations to Supabase with strict Row Level Security (RLS).

### 5. UI Presentation
- **`SocialHubScreen`**: Tabbed hub (Squads, Family, Feed, Clubs & Leaderboards).
- **`SquadDetailScreen`**: Squad room with live streak, micro-commitments, and emergency nudges.
- **`FamilyHealthHubScreen`**: Parents' vital health cards, risk status indicators, and blessing actions.

---

## Verification
- Unit Tests: `test/social_test.dart`
- Supabase Migration: `supabase/migrations/20260912000009_phase9_social_schema.sql`
