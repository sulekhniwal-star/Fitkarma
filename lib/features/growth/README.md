# Growth Feature (`lib/features/growth/`)

## Purpose
Manages WhatsApp Business Cloud API integration, Vernacular ASR voice parser (Hindi, Tamil, Telugu, Marathi, Bengali, Kannada), ABHA Health ID OAuth linking, and Grocery Vendor Adapters (Blinkit/BigBasket/Zepto).

## Subdirectories
- **`models/`**: `AbhaAccount`, `VernacularVoiceLog`, and `GroceryVendorAdapter` data models.
- **`providers/`**: Riverpod state management for WhatsApp opt-ins, ABHA link status, and language choices.
- **`screens/`**: Interactive `GrowthTrustScreen` displaying WhatsApp status, ABHA OAuth badge, and vendor adapters.
