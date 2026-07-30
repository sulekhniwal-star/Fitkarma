# AI Coach Feature (`lib/features/coach/`)

## Purpose
Manages the AI Coach Chat UI, prompt templates, multi-model tier routing, and conversation memory windows.

## Subdirectories
- **`models/`**: Data structures for `ChatMessage`, `ConversationSummary`, and prompt templates.
- **`providers/`**: Riverpod state management for conversation history, last-5 memory window, and Groq API calls.
- **`screens/`**: Interactive `CoachChatScreen` with tier badge indicators and quick prompt chips.
