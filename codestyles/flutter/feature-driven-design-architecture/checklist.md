# Checklist — flutter/feature-driven-design-architecture

All must be yes.

- [ ] `lib/` root holds only app-level files (`main.dart` / `app.dart`) + `features/` + `shared/` — no loose feature code.
- [ ] Each feature is a snake_case folder under `features/`, named by domain (not by layer).
- [ ] Each feature has `data/` + `presentation/` (no `logic/` created by this idiom).
- [ ] `data/` contains only `models/` + `repositories/`.
- [ ] `models/` = plain data classes (fields + `fromJson`/`toJson`); no `package:flutter` widget imports.
- [ ] `repositories/` files `*_repository.dart`, class `*Repository`, return models.
- [ ] `presentation/` contains only `screens/` + `widgets/`.
- [ ] `screens/` = one full page/route per file, `*_screen.dart`, class `*Screen`.
- [ ] `widgets/` = feature-scoped reusable UI, not full pages.
- [ ] `shared/` contains only `widgets/` + `utils/` + `themes/`, holding code reused by ≥2 features.
- [ ] No widget/util duplicated across features (shared code promoted to `shared/`).
- [ ] All folders + files snake_case; one public class per file, PascalCase matching filename.
