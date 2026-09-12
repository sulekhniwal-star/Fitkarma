# FitKarma — API Contract (Supabase Edge Functions)

All endpoints are Supabase Edge Functions (Deno/TypeScript), invoked via the Supabase client SDK (`supabase.functions.invoke`) with the user's session JWT attached automatically. Service-role-only endpoints (webhooks) are called by third parties directly, not by the client.

## Conventions
- Request/response bodies: JSON.
- Auth: user JWT required unless marked "service-only" (webhook).
- Errors: standard shape (see `error_handling.md` §3) — `{ "error": { "code": string, "message": string } }`.

## 1. `POST /functions/v1/generate-dip`
Generates or returns the cached Daily Intelligence Package for the caller.
- **Request**: `{ "date": "YYYY-MM-DD" }`
- **Response**: `{ "readiness": {...}, "nutrition_plan": {...}, "workout_plan": {...}, "coach_note": string, "generated_at": timestamp }`

## 2. `POST /functions/v1/coach-message`
Sends a message to the AI adaptive coach.
- **Request**: `{ "session_id": uuid, "message": string, "context_refresh"?: boolean }`
- **Response**: `{ "reply": string, "model_used": "llama-3.3-70b" | "mixtral" | "llama-3.2-11b" }`

## 3. `POST /functions/v1/log-meal-photo`
Analyzes a food photo (vision model) and returns a structured meal estimate for the client to confirm before writing to `meals`.
- **Request**: `{ "image_path": string }` (Storage path, already uploaded by the client)
- **Response**: `{ "recipe_match": {...} | null, "estimated_items": [...], "confidence": number }`

## 4. `POST /functions/v1/revenuecat-webhook` (service-only)
Verifies RevenueCat webhook signature and upserts `entitlements`.
- **Request**: RevenueCat's standard webhook payload.
- **Response**: `204 No Content` on success; `401` on signature failure.

## 5. `POST /functions/v1/delete-user-data`
Triggers the DPDP cascading erasure for the caller's own account (or an admin-triggered variant via FitKarma Hub, service-role only).
- **Request**: `{ "confirm": true }`
- **Response**: `{ "receipt_id": uuid, "deleted_at": timestamp }`

## 6. `POST /functions/v1/abha-token-exchange`
Exchanges an ABHA M1 token for a Supabase-compatible custom JWT claim.
- **Request**: `{ "abha_id": string, "m1_token": string }`
- **Response**: `{ "linked": true }` and sets the `abha_linked` custom claim on the user's session.

## 7. `POST /functions/v1/whatsapp-webhook` (service-only)
Meta WhatsApp Business Cloud API inbound webhook for logging via chat.
- **Request**: Meta's standard webhook payload.
- **Response**: `200 OK`.

## 8. `POST /functions/v1/generate-doctor-dossier`
Generates a PDF dossier and returns a signed URL, scoped to an active `doctor_access_grants` row.
- **Request**: `{ "grant_id": uuid }`
- **Response**: `{ "signed_url": string, "expires_at": timestamp }`

## 9. `GET /functions/v1/grocery-prices`
Reads from the `grocery_price_matrix` cache (see `data_sources.md`, `scrapping_spec.md`) for a given ingredient list.
- **Request query params**: `?ingredients=id1,id2,id3`
- **Response**: `{ "prices": [{ "ingredient_id": uuid, "vendor": string, "price": number, "source": "api"|"scrape"|"manual", "last_verified_at": timestamp }] }`

## Versioning
Breaking changes to any contract above require a version bump in the function path (e.g. `/functions/v1/` → `/functions/v2/`) and a `decisions.md` entry — no silent breaking changes to a shipped contract.
