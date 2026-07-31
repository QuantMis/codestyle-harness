# Flutter — Codestyle Catalog

Flutter idioms. `apply-codestyle` reads this to pick idioms per task. One row per idiom.

| Idiom | Use when | Related |
|-------|----------|---------|
| [`feature-driven-design-architecture`](./feature-driven-design-architecture/STYLE.md) | Structuring `lib/` feature-first — scaffold or refactor. Data + presentation layers. | `state-management-via-provider` |
| [`state-management-via-provider`](./state-management-via-provider/STYLE.md) | Feature state/logic via `provider` + `ChangeNotifier`. Fills the `logic/` layer. | `feature-driven-design-architecture` |

<!--
Add a row (or use add-codestyle):
| [`name`](./name/STYLE.md) | terse "use when…" | related idioms |
-->
