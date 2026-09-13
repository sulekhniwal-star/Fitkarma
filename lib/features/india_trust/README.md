# India Growth & Trust Layer (FitKarma Phase 16)

FitKarma's India Growth & Trust Layer bridges personal fitness and nutrition tracking with India's public and private digital health infrastructure (ABDM, WhatsApp, Vernacular NLP, Quick-Commerce, and Corporate Insurer rails).

---

## Key Capabilities

1. **Ayushman Bharat Digital Mission (ABDM) & ABHA Health ID (`AbhaIntegrationEngine`)**:
   - 14-digit ABHA ID validation (`XX-XXXX-XXXX-XXXX`) and `@abdm` PHR address linkage.
   - Server-side M1 token exchange via Edge Function `abha-token-exchange` setting custom JWT claim `abha_linked: true`.
   - Automated conversion of lab biomarkers and biological age into HL7 FHIR DiagnosticReport bundles for doctor sharing.

2. **WhatsApp Business Natural Language Logging (`WhatsAppLoggingEngine`)**:
   - Inbound Meta Cloud API webhook (`whatsapp-webhook`) parsing vernacular text and audio notes.
   - Automated bilingual responses with calorie, protein, and Karma streak confirmations.

3. **Vernacular Voice Logging (`VernacularVoiceEngine`)**:
   - Multi-lingual entity extraction from Hinglish, Hindi, and English voice speech.
   - Automatically maps regional items (Roti, Katori Dal, Paneer, Dahi, Desi Dand, Baithak, Surya Namaskar) directly to macros and calories.

4. **Corporate Wellness & Insurer Rebate Tier (`CorporateWellnessEngine`)**:
   - Real-time Team Wellness Index (0-100) scoring.
   - Dynamic health insurance premium discount calculator (up to 15% annual premium savings).

5. **Quick-Commerce Grocery Cart Integration (`QuickCommerceEngine`)**:
   - Live comparative basket pricing across Blinkit, Zepto, and Instamart.
   - 1-click deep link cart exporter for high-protein Indian grocery items.

6. **Offline-First Persistence & Synchronization**:
   - Local Drift tables: `LocalAbhaRecords`, `LocalWhatsappLogs`, `LocalCorporateTeams`.
   - Outbox sync via `OutboxSyncWorker`.
   - Supabase schema: `abha_records`, `whatsapp_logs`, `corporate_teams` with RLS.
