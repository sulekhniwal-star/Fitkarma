# FitKarma 🇮🇳

**India's Intelligent Health Operating System** — an AI-adaptive fitness, nutrition, longevity, and wellness platform custom-engineered for the Indian lifestyle.

> **Master Spec:** [`FitKarma_Documentation_v2.md`](./FitKarma_Documentation_v2.md)  
> **Development Workflow:** [`SKILL.md`](./SKILL.md)  
> **Task Tracker:** [`TODO.md`](./TODO.md)  
> **Test Suite:** **145/145 passing tests (100%)** | `flutter analyze` **0 issues**

---

## 🚀 Key Highlights & Moats

1. **Daily Intelligence Package (DIP)**: Orchestrated daily health synthesis engine replacing fragmented AI calls with unified morning briefings.
2. **Smart Indian Nutrition & Quick-Commerce**: 18 specialized nutritional intelligence engines + 1-Tap checkout & price comparison across **Blinkit, Zepto, Swiggy Instamart, BigBasket, Amazon Fresh**, and **Local Kirana WhatsApp slips**.
3. **Advanced Metabolism & Longevity**: Dynamic TDEE adaptive metabolism tracking, 7 hallmarks of biological longevity scoring, and real-time Environmental Health mitigation (AQI/Heat Index/UV).
4. **India Growth & Trust Layer**: WhatsApp Business Meta Cloud API logging, Vernacular Voice logging (Hindi, Hinglish, Tamil, Telugu), Ayushman Bharat Health Account (**ABHA ID / ABDM**), and Corporate Wellness Insurer Rebates.
5. **Privacy & DPDP Act 2023 Compliant**: Built-in cryptographic right-to-erasure cascading deletion (`deleteUserData`) covering all user subcollections, cross-references, and Cloud Storage buckets.

---

## 🛠 Tech Stack

| Layer | Technology | Details |
| :--- | :--- | :--- |
| **Frontend Framework** | Flutter 3.x / Dart | Android + iOS + Web single codebase |
| **State Management** | Riverpod 2.x | Reactive `StateNotifierProvider` pattern |
| **UI Design System** | Glassmorphic Bento Grid | Custom Dark Palette (`#0D0F12`), Spring Physics, Bilingual Hindi/English labels |
| **Cloud Database** | Firebase Firestore | Offline persistence + granular security isolation rules |
| **Backend Compute** | Firebase Cloud Functions v2 | Node.js JavaScript microservices for AI routing, webhooks, and DPDP compliance |
| **Authentication** | Firebase Authentication | Phone OTP, Google Sign-In, ABHA Token M1 Auth |
| **Cloud Storage** | Firebase Cloud Storage | Progress photos, meal vision captures, clinical reports |
| **AI Routing Engine** | Groq SDK (Server-Side) | Multi-model routing (Llama-3.3-70b, Mixtral, Llama-3.2 Vision) |
| **Monetisation** | RevenueCat SDK | Server-verified subscription webhooks |

---

## 📁 Repository Structure

```
fitkarma/
├── lib/
│   ├── features/                   # Modular feature architecture
│   │   ├── abha_integration/       # ABDM / ABHA Health ID M1-M3 integration
│   │   ├── corporate_wellness/     # B2B Corporate dashboard & insurer rebates
│   │   ├── environmental_health/   # AQI, Heat Index, and UV adaptive engine
│   │   ├── metabolism/             # Adaptive TDEE & metabolic adaptation
│   │   ├── nutrition/              # 18 nutrition engines & Quick-Commerce checkout
│   │   ├── predictive_health/      # Longevity score, CGM pipeline, Doctor Dossier
│   │   ├── recovery/               # Sleep intelligence, soreness heatmap, circadian clock
│   │   ├── security/               # Enterprise security evaluator & biometric gates
│   │   ├── vernacular_voice/       # Multi-lingual Indian voice food logging
│   │   ├── whatsapp_logging/       # WhatsApp Meta Cloud API conversation logging
│   │   └── workout/                # Progressive overload & computer vision pose tracking
│   ├── shared/                     # Reusable Bento UI widgets, theme & design system
│   └── main.dart                   # Application entry point
├── functions/                      # Firebase Cloud Functions (v2 JavaScript)
│   ├── aiRouter/                   # Groq multi-model routing
│   ├── compliance/                 # DPDP Act 2023 cascading deletion (deleteUserData)
│   ├── healthOS/                   # Daily Intelligence Package orchestration
│   └── webhooks/                   # RevenueCat & WhatsApp webhook handlers
├── docs/                           # Standalone technical documentation for all features
├── test/                           # 145+ automated unit & widget tests
├── firestore.rules                 # User data isolation security rules
├── storage.rules                   # Storage access security rules
├── FitKarma_Documentation_v2.md    # Master architecture documentation
└── TODO.md                         # Master 16-phase roadmap checklist
```

---

## 🧪 Testing & Verification

Run the complete offline test suite:
```bash
flutter test
```
*Current test suite passing status: 145/145 tests.*

Run the Dart & Flutter static code analyzer:
```bash
flutter analyze
```
*Current status: No issues found.*

---

## ⚖️ License & Data Protection

- **License:** Proprietary — All rights reserved.
- **Data Protection:** Compliant with India's **Digital Personal Data Protection (DPDP) Act 2023** and **Ayushman Bharat Digital Mission (ABDM)** standards.
