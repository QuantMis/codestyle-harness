---
framework: flutter
name: feature-driven-design-architecture
tags: [architecture, folder-structure, feature-first, scaffold, refactor]
use-when: Structuring `lib/` feature-first — new app scaffold, or refactoring flat/layer-first `lib/` into features. Covers data + presentation layers.
use-when-not: Logic/state-management layer conventions (→ `state-management-via-provider`, separate idiom). Trivial single-screen app. Package/plugin internal layout.
related: [state-management-via-provider]
---

# Flutter — Feature-Driven Design Architecture

## Intent

Feature-first folder skeleton. Group by **domain capability**, not technical layer. Each feature self-contained: `data/` (models + repositories) + `presentation/` (screens + widgets). Cross-feature code → `shared/`. Logic/state layer added by separate idiom. Same skeleton drives greenfield scaffold + refactor of layer-first trees.

## Conventions

1. `lib/` root holds only app-level files (`main.dart`, `app.dart`) + two folders: `features/` + `shared/`. No feature code loose at `lib/` root.
2. `features/<feature>/` — one folder per user-facing capability, snake_case domain name (`authentication`, `home`, `profile`). Feature ≠ technical layer.
3. Each feature has `data/` + `presentation/`. (`logic/` owned by `state-management-via-provider` — not created here.)
4. `data/` splits into `models/` + `repositories/` only.
   - `models/` — plain data classes: fields + (de)serialization (`fromJson`/`toJson`). No Flutter widget imports, no UI.
   - `repositories/` — data access (fetch/persist), return models. Suffix `_repository.dart` / class `*Repository`.
5. `presentation/` splits into `screens/` + `widgets/` only.
   - `screens/` — one full page/route per file. Suffix `_screen.dart` / class `*Screen`.
   - `widgets/` — feature-scoped reusable UI. Not full pages.
6. `shared/` holds cross-feature code only (reused by ≥2 features): `widgets/` (app-wide UI), `utils/` (helpers, extensions, constants), `themes/` (`ThemeData`, colors, text styles). Reused-by-≥2 → promote to `shared/`, never duplicate per feature.
7. Naming: folders + files snake_case (`login_screen.dart`). One public class per file; class PascalCase matching filename (`login_screen.dart` → `LoginScreen`).
8. Refactor path: move each file to `features/<feature>/<layer>/<bucket>/`; loose model → `data/models/`, loose page → `presentation/screens/`; anything two features share → `shared/`.

## Canonical example

`example.txt` — annotated `lib/` tree: `authentication` + `home` features + `shared/`.

## Anti-patterns

- Layer-first root (`lib/models/`, `lib/screens/`, `lib/widgets/`) — scatters one feature across the tree.
- Feature code loose at `lib/` root (files outside `features/` or `shared/`).
- Same widget/util copied into multiple features instead of promoted to `shared/`.
- Full page dumped in `widgets/`; reusable partial declared as a `*Screen`.
- Data model importing `package:flutter/*` or holding widgets.
- PascalCase / camelCase file or folder names (Dart = snake_case).
- Creating `logic/`, `providers/`, `cubit/`, `bloc/` here — that's the `state-management-via-provider` idiom.
