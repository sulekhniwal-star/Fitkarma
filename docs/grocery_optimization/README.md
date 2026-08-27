# Grocery Optimization Engine (Budget-Optimized Flow)

## 1. Feature Description
Compiles a 7-day budget-optimized Indian grocery shopping list tailored to user dietary preferences, calculating cost-per-gram-of-protein (₹ / g Protein), total weekly protein yield, and instant export to quick-commerce delivery apps.

## 2. Spec Reference
- **Specification:** `FitKarma_Documentation.md` (Phase 5 — Smart Indian Nutrition, §P5 Grocery Optimization Engine)
- **Phase:** Phase 5 — Smart Indian Nutrition

## 3. Key Files & Responsibilities
- `lib/features/nutrition/domain/grocery_optimization_engine.dart`: Pure Dart calculation engine determining cost-per-gram protein indices, weekly grocery item quantities, and budget aggregations.
- `lib/features/nutrition/presentation/grocery_optimization_screen.dart`: Interactive grocery checklist screen with estimated INR budget metrics, vegetarian/non-veg toggle, and copy-to-clipboard functionality.

## 4. Firestore Collections & Fields
- **Data paths:**
  - Reads: User profile diet preferences (`/users/{uid}`)
  - Writes: Optional persistence to `/users/{uid}/groceryLists/{listId}`
- **Security rules:** Nested under `/users/{userId}/**` with strict authenticated owner validation (`request.auth.uid == userId`).

## 5. Deterministic vs. AI Logic Split
- **Deterministic:** 100% deterministic grocery item aggregation, cost arithmetic, and protein efficiency ratios in pure Dart.
- **AI Logic:** None in core grocery optimization engine.

## 6. Deviations from Spec
- None. Fully adheres to Grocery Optimization Engine specifications.
