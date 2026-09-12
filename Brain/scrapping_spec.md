# FitKarma — Scraping Spec (Grocery Price Matrix)

## 1. Scope
This spec covers the fallback data path for `grocery_price_matrix` (P16, Multi-Vendor Grocery Checkout Integration) — used only where an official partner/affiliate API isn't available or doesn't cover a needed vendor/item.

## 2. Before scraping anything
- Check each vendor's current Terms of Service and robots.txt. Several quick-commerce platforms explicitly restrict automated data collection — where that's the case, scraping is not a viable path for that vendor and the item should fall back to `manual` or be omitted from the matrix, not scraped anyway.
- Prefer an official partner, affiliate, or public API first for every vendor on the list (Blinkit, Zepto, Swiggy Instamart, BigBasket, Amazon Fresh); reach out to their partnerships/business channels before building scraping infrastructure.
- Record the ToS decision per vendor in `decisions.md` (allowed / not allowed / pending) so this doesn't get re-litigated per engineer.

## 3. Where scraping is confirmed permissible
- **Scope narrowly**: only the specific product categories used in the app's nutrition/grocery-swap flows — not a general catalog crawl.
- **Rate limit aggressively**: schedule as a low-frequency batch job (e.g. daily), not real-time per-user lookups, to minimize load on the vendor and reduce the chance of being blocked.
- **Identify honestly**: use a descriptive User-Agent and respect `robots.txt` disallow rules; don't spoof identity to evade a vendor's stated access policy.
- **Cache aggressively**: store results in `grocery_price_matrix` with `source = 'scrape'` and a `last_verified_at` timestamp; serve from cache, don't re-fetch per app request.
- **Fail gracefully**: if a vendor blocks or changes markup, degrade to the last cached price (flagged stale) rather than retrying aggressively or trying to circumvent the block.

## 4. Architecture
- Runs as a scheduled Supabase Edge Function (or an external scheduled job if execution time exceeds Edge Function limits), never triggered client-side.
- Writes go through the service role directly to `grocery_price_matrix` — this table has no client-facing write policy.
- Normalization step maps vendor-specific product names/units to FitKarma's internal recipe/ingredient IDs before storage.

## 5. Legal/compliance note
This is a business-risk area, not just a technical one — vendor ToS enforcement, changes in policy, or takedown requests can remove a data source with no notice. The matrix should be built to degrade gracefully (fewer vendors shown, not a broken feature) rather than assume permanent availability of any single source. Route any vendor cease-and-desist or legal contact straight to whoever is handling FitKarma's legal review, not just to a code fix.

## 6. Explicitly out of scope
- Scraping any vendor's login-gated pricing, personalized/user-specific prices, or anything behind an account wall.
- Any technique intended to evade bot-detection or rate-limiting that a vendor has put in place — if a vendor blocks the request, that vendor is dropped from the matrix, not worked around.
