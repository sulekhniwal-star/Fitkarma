# FitKarma - Comprehensive Execution Plan

**Generated:** February 2026  
**Based on:** Complete Development Plan Document  
**Current Project State:** Phase 1 (MVP) ~60% Complete

---

## Table of Contents

1. [Gap Analysis Summary](#gap-analysis-summary)
2. [Implemented Features](#implemented-features)
3. [Missing Features - Priority Matrix](#missing-features---priority-matrix)
4. [Prioritized Implementation Roadmap](#prioritized-implementation-roadmap)
5. [Technical Architecture Refinements](#technical-architecture-refinements)
6. [Missing Backend Collections](#missing-backend-collections)
7. [Next Steps](#next-steps)

---

## Gap Analysis Summary

Based on the comprehensive development plan and current codebase analysis:

| Phase | Plan Features | Implemented | Gap |
|-------|--------------|-------------|-----|
| **Phase 1 (MVP)** | ~25 core features | ~15 features | **40% gap** |
| **Phase 2** | ~20 features | 0 features | **100% gap** |
| **Phase 3** | ~15 features | 0 features | **100% gap** |
| **Phase 4-5** | ~15 features | 0 features | **100% gap** |

### Current Completion: ~35% of Total MVP

---

## Implemented Features

### ✅ Authentication & Onboarding
- [x] Email/password authentication via PocketBase
- [x] Login screen with form validation
- [x] Onboarding questionnaire (age, gender, height, weight, goals)
- [x] Dosha quiz (Ayurvedic constitution assessment)
- [x] User profile model with all required fields

### ✅ Dashboard
- [x] Time-based greetings (Hindi + English)
- [x] Karma points display
- [x] Dosha routine section
- [x] Health metrics grid (steps, calories, water, workout)
- [x] Quick action buttons

### ✅ Food & Nutrition
- [x] Food database schema (500+ fields ready)
- [x] Food search with filters (category, cuisine, vegetarian)
- [x] Multi-language support (name_hindi, name_tamil)
- [x] Food logging by meal type
- [x] Nutrition calculation (calories, protein, carbs, fats, fiber, sugar)
- [x] Daily nutrition summary card
- [x] Meal-wise breakdown display
- [x] Barcode field in schema (ready for scanning)

### ✅ Health Tracking
- [x] Steps tracking repository
- [x] Water intake logging
- [x] Weight tracking with history
- [x] Daily/weekly summaries

### ✅ Gamification
- [x] Karma points system
- [x] Karma tiers (Bronze, Silver, Gold, Platinum, Diamond)
- [x] Karma transactions tracking
- [x] Karma screen with history

### ✅ Backend Infrastructure
- [x] PocketBase setup
- [x] User authentication collection
- [x] Food items collection with comprehensive schema
- [x] Food logs collection
- [x] Steps logs collection
- [x] Water logs collection
- [x] Weight logs collection
- [x] Workouts library collection
- [x] Workout logs collection
- [x] Ayurvedic data seeded
- [x] Karma tiers seeded

---

## Missing Features - Priority Matrix

### 🔴 Critical (Must Have for MVP Launch)

| Feature | Priority | Plan Section | Backend Needed |
|---------|----------|--------------|----------------|
| **User Profile Screen** | P0 | 3.1.A | Users collection exists |
| **Settings Screen** | P0 | 3.1.A | New collection likely |
| **Workout Library Screen** | P0 | 3.1.F | Collection exists |
| **Workout Player/Logging** | P0 | 3.1.F | Collection exists |
| **Push Notifications (FCM)** | P0 | Roadmap | Firebase setup |
| **Offline Sync (Hive)** | P0 | 4.5 | Local storage |
| **Bottom Navigation** | P0 | Navigation | None |

### 🟡 Important (Enhance MVP)

| Feature | Priority | Plan Section | Backend Needed |
|---------|----------|--------------|----------------|

### 🟢 Nice to Have (Phase 2+)

| Feature | Priority | Plan Section |
|---------|----------|--------------|
| Live Classes | P2 | 3.2.L |
| AI Coaching | P3 | 3.2.K |
| Voice Logging | P3 | 3.1.D |
| Recipe Builder | P3 | 3.1.D |
| Meal Prep Planner | P3 | 3.1.D |
| Habit Stacking | P3 | 3.2.M |
| Fasting Tracker | P3 | 3.2.N |
| Mood Tracking | P3 | 3.1.C |
| Sleep Tracking | P3 | 3.1.C |
| Menstrual Cycle | P3 | 3.1.C |
| Wearable Integration | P4 | 3.2.O |
| WhatsApp Bot | P4 | 3.1.D |

---

## Prioritized Implementation Roadmap

### Phase 1.5: Navigation & Core UI (Week 1-2)

**Goal:** Complete the app shell and connect all existing features

```
Week 1: Bottom Navigation & App Shell
├── Implement bottom navigation bar
│   ├── Home/Dashboard tab
│   ├── Food tab
│   ├── Workout tab
│   ├── Community tab
│   └── Profile tab
├── Add navigation between all existing screens
└── Fix issues routing

Week 2: Profile & Settings
├── Create Profile Screen
│   ├── Display user info (name, weight, goal)
│   ├── Edit profile functionality
│   ├── Photo upload
│   └── Stats display
├── Create Settings Screen
│   ├── Language selection
│   ├── Notification preferences
│   ├── Privacy settings
│   └── Logout
└── Connect auth state to navigation
```

**Deliverables:**
- [ ] Bottom navigation with 5 tabs
- [ ] Profile screen with edit functionality
- [ ] Settings screen
- [ ] Proper auth flow (redirect to login if not authenticated)

---

### Phase 1.6: Workout System (Week 3-4)

**Goal:** Complete the workout feature for MVP

```
Week 3: Workout Library & Player
├── Create Workout Library Screen
│   ├── Categories (Yoga, Bollywood, HIIT, Desi, Gym)
│   ├── Difficulty filters
│   ├── Duration filters
│   └── Video thumbnail display
├── Create Workout Detail Screen
│   ├── Workout info (title, description, duration)
│   ├── Calorie estimate
│   ├── Difficulty level
│   └── Start workout button
├── Implement Workout Player
│   ├── Video playback (YouTube embed)
│   ├── Timer functionality
│   └── Pause/resume controls
└── Create Workout Logging Flow
    ├── Post-workout summary
    ├── Rate workout (1-5 stars)
    ├── Notes input
    └── Karma awarded

Week 4: Workout Schedules
├── Create Weekly Schedule Screen
├── Implement workout reminders
└── Add workout completion tracking
```

**Deliverables:**
- [ ] Workout library with all categories
- [ ] Workout player with timer
- [ ] Workout logging with karma rewards
- [ ] Weekly workout schedule

---

### Phase 1.7: Notifications & Offline (Week 5-6)

**Goal:** Add push notifications and offline support using PocketBase

```
Week 5: Push Notifications
├── Setup Firebase Cloud Messaging
├── Create notification service
├── Implement notification types
│   ├── Daily reminder (steps, water)
│   ├── Meal logging reminder
│   ├── Workout reminder
│   └── Streak maintenance
└── Add notification scheduling

Week 6: Offline Support
├── Setup Hive for local storage
├── Implement offline-first architecture
│   ├── Cache food database locally
│   ├── Cache workouts locally
│   ├── Queue actions when offline
│   └── Sync when online
└── Add sync status indicator
```

**Deliverables:**
- [ ] Push notifications via PocketBase realtime
- [ ] Offline-first data flow
- [ ] Sync status UI

---

### Phase 1.8: Beta Launch Preparation (Week 7-8)

**Goal:** Prepare for beta testing with 50 users

```
Week 7: Polish & Testing
├── Fix all known bugs
├── UI/UX improvements based on testing
├── Performance optimization
├── Add loading states and error handling
└── Security review

Week 8: Beta Launch
├── Prepare Play Store listing
├── Prepare App Store listing
├── Create privacy policy and terms
├── Setup crash reporting (Sentry or local)
├── Setup analytics (Mixpanel)
├── Launch to 50 beta testers
└── Gather feedback
```

**Deliverables:**
- [ ] Beta release on Play Store
- [ ] Crash reporting active
- [ ] Analytics tracking
- [ ] 50 beta testers

---

## Phase 2: Health & Community (Month 5-7)

### Month 5: Medical Integration
```
├── Medical Report Upload UI
├── OCR Integration (Google ML Kit)
│   ├── Text recognition
│   ├── Value extraction (HbA1c, Cholesterol, etc.)
│   └── Manual verification flow
├── Health markers display
├── Personalized recommendations
└── Disclaimer implementation
```

### Month 6: Community Features
```
├── Social Feed
│   ├── Post creation (workout, meal, progress)
│   ├── Like/comment/share
│   ├── Hashtags and tags
│   └── Language-based feed filtering
├── Regional Communities
│   ├── Auto-join based on language
│   ├── Community-specific feeds
│   └── Regional content
├── Friend System
│   ├── Find friends
│   ├── Send/receive requests
│   ├── Friend list
│   └── Private messaging
└── Challenges System
    ├── Pre-built challenges
    ├── Challenge participation
    ├── Progress tracking
    └── Leaderboards
```

### Month 7: Expanded Workouts
```
├── GPS Workout Tracking
│   ├── Route mapping (OpenStreetMap)
│   ├── Pace tracking
│   └── Distance calculation
├── Health Connect / Apple Health Sync
├── Sleep Tracking (manual logging)
├── Mood Tracking
└── Expand Workout Library to 50 videos
```

---

## Phase 3: Cultural Integration (Month 8-10)

### Month 8: Festival & Ayurveda
```
├── Festival Calendar
├── Festival-specific Challenges
├── Healthy Festival Recipes (20+)
├── Festival Guides (Diwali, Holi, Navratri, etc.)
├── Ayurvedic Features
│   ├── Dosha-based diet tips
│   ├── Daily routines (Dinacharya)
│   ├── Seasonal recommendations
│   └── Herbal remedies section
└── Full Localization (10 languages)
```

### Month 9: Advanced Features
```
├── Recipe Builder
├── Meal Prep Planner
├── Custom Diet Plan Generator
├── Habit Stacking Tracker
├── Fasting Tracker
│   ├── Intermittent Fasting (16:8, 18:6)
│   ├── Religious Fasts (Navratri, Ramadan)
│   └── Vrat-friendly recipes
├── Menstrual Cycle Tracking
├── Voice Logging (Speech-to-Text)
└── Family Plan Subscription
```

### Month 10: Live Classes & Premium
```
├── Live Class Schedule (YouTube Live)
├── 2 Live classes/week
├── Recorded Class Library (Premium)
├── Advanced Analytics Dashboard
├── PDF Export
├── Ad Integration (AdMob)
└── Premium Feature Refinement
```

---

## Technical Architecture Refinements

### Current Architecture Assessment

| Aspect | Current State | Recommendation |
|--------|--------------|----------------|
| **State Management** | Riverpod 2.x ✅ | Keep - Good choice |
| **Routing** | Go Router ✅ | Keep - Clean API |
| **Local Storage** | Not implemented ❌ | Add Hive + PocketBase |
| **Backend** | PocketBase ✅ | Keep - Cost-effective, no Firebase |
| **Notifications** | None ❌ | Use PocketBase realtime |
| **Offline Support** | None ❌ | Implement offline-first |

### Recommended Additions

#### 1. Add Hive for Offline Storage

```yaml
# pubspec.yaml additions
dependencies:
  hive: ^2.2.3
  hive_flutter: ^1.1.0
```

**Implementation Strategy:**
- Cache user profile locally
- Cache food database (top 500 items)
- Cache workout library
- Queue food/workout logs when offline
- Sync when connectivity restored

#### 2. Notification Architecture (PocketBase)

```yaml
# Use PocketBase realtime subscriptions instead of Firebase
dependencies:
  hive: ^2.2.3
  hive_flutter: ^1.1.0
```

**PocketBase Realtime Approach:**
- Subscribe to notification collection changes
- Use PocketBase's built-in realtime to trigger local notifications
- Store notification preferences in user settings
- No external Firebase required

**Notification Types:**
| Type | Trigger | Priority |
|------|---------|----------|
| Morning Reminder | 7:00 AM daily | High |
| Meal Reminder | 1 hour after last meal | Medium |
| Water Reminder | Every 2 hours | Medium |
| Workout Reminder | Scheduled time | High |
| Streak Warning | End of day if streak at risk | High |

#### 3. OCR for Medical Reports

```yaml
dependencies:
  google_ml_kit: ^0.16.3
  image_picker: ^1.0.7
```

**Implementation:**
- Use Google ML Kit Text Recognition
- Extract values using regex patterns
- Show verification screen
- Store verified data in medical_reports collection

#### 4. Maps for GPS Workouts

```yaml
dependencies:
  geolocator: ^11.0.0
  flutter_map: ^6.1.0
  latlong2: ^0.9.0
```

---

## Missing Backend Collections

Based on the plan, the following collections need to be created:

### Phase 1.5-1.8 (MVP Completion)

| Collection | Purpose | Fields |
|------------|---------|--------|
| `settings` | User preferences | user_id, language, notifications, units, theme |
| `notifications` | Push notification logs | user, type, scheduled, sent, read |
| `medical_reports` | Uploaded health reports | user, report_file, extracted_data, verified |

### Phase 2 (Health & Community)

| Collection | Purpose | Fields |
|------------|---------|--------|
| `posts` | Social feed posts | user, content, type, media, tags, likes, comments |
| `comments` | Post comments | post, user, content, likes |
| `likes` | Like records | user, post/comment |
| `challenges` | Challenge definitions | title, type, start_date, end_date, goal, reward |
| `challenge_progress` | User challenge progress | challenge, user, current_value, completed |
| `friendships` | Friend connections | user, friend, status |
| `messages` | Private messages | from, to, content, read |
| `sleep_logs` | Sleep tracking | user, date, bedtime, wake_time, quality |
| `mood_logs` | Mood tracking | user, date, mood, energy, stress, note |

### Phase 3+ (Advanced Features)

| Collection | Purpose | Fields |
|------------|---------|--------|
| `recipes` | User-created recipes | user, title, ingredients, nutrition, steps |
| `meal_preps` | Meal prep plans | user, week, meals, shopping_list |
| `habits` | Habit tracking | user, name, frequency, streak, completed_dates |
| `fasts` | Fasting logs | user, type, start_time, end_time |
| `cycles` | Menstrual cycle | user, start_date, end_date, symptoms |
| `subscriptions` | Premium subscriptions | user, plan, start, end, status, razorpay_id |
| `experts` | Verified coaches/nutritionists | user, credentials, specialty, rate, verified |
| `consultations` | Expert consultations | user, expert, date, status, notes |

---

## Next Steps

### Immediate Actions (This Week)

1. **Create implementation plan for Phase 1.5**
   - Break down into daily tasks
   - Assign priorities
   - Set deadlines

2. **Start with Bottom Navigation**
   - Create app shell
   - Connect all existing screens
   - Test navigation flow

3. **Set up Hive**
   - Initialize Hive in main.dart
   - Create local storage service

### This Month's Goals

- [ ] Complete Phase 1.5 (Navigation & Core UI)
- [ ] Complete Phase 1.6 (Workout System)
- [ ] Complete Phase 1.7 (Notifications & Offline)
- [ ] Begin Phase 1.8 (Beta Launch Prep)

### Success Metrics for MVP

| Metric | Target |
|--------|--------|
| Beta Testers | 50 users |
| Daily Active Users | 100+ |
| D7 Retention | 20%+ |
| Crash Rate | <1% |
| App Rating | 4.0+ |

---

## Appendix: Feature Priority Quick Reference

### P0 - Critical (Launch Blockers)
- Bottom Navigation
- Profile Screen
- Settings Screen
- Workout Library
- Workout Player
- Push Notifications
- Offline Sync

### P1 - Important (Launch Enhancers)
- Medical Report Upload
- Challenges System
- Social Feed
- Friends System
- Leaderboards

### P2 - Nice to Have (Post-Launch)
- Live Classes
- Recipe Builder
- Voice Logging
- Advanced Analytics

### P3 - Future (Phase 2+)
- AI Coaching
- Wearables
- WhatsApp Bot
- Marketplace

---

*This execution plan should be reviewed and updated weekly during development.*
