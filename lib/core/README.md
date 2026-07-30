# Core Module (`lib/core/`)

## Purpose
The `core` module houses application-wide singletons, configurations, decision algorithms, and central intelligence components.

## Subdirectories
- **`brain/`**: Contains the **Health OS Brain**, Daily Intelligence Package (DIP) models, and local decision hierarchy resolvers.
- **`router/`**: Multi-model AI routing engine (rule evaluator, prompt tier selector) and app-level GoRouter navigation configuration.
- **`config/`**: Multi-environment configurations (`staging` vs `production`) reading `--dart-define` values.
