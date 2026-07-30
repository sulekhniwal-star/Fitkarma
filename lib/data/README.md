# Data Module (`lib/data/`)

## Purpose
The `data` module manages local and remote persistence, encryption, and sync engines for FitKarma.

## Subdirectories
- **`local/`**: Contains Drift SQLite database schemas, SQLCipher AES-256 encryption initializers, secure storage accessors, and local DAOs.
- **`sync/`**: Contains the Cloudflare D1 custom sync engine, priority queue resolvers, offline change logs, and Last-Write-Wins (LWW) conflict resolvers.
