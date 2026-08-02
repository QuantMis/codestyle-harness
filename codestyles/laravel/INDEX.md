# Laravel — Codestyle Catalog

Laravel idioms. `apply-codestyle` reads this to pick idioms per task. One row per idiom.

| Idiom | Use when | Related |
|-------|----------|---------|
| [`livewire-project-init`](./livewire-project-init/STYLE.md) | Day-0 scaffold of a Laravel + Livewire app — install command, skeleton, quality-gate baseline. DB-independent (SQLite); pulls in Flux UI. | `everything-modular`, `crud-controller` |
| [`everything-modular`](./everything-modular/STYLE.md) | Placing any file in a Laravel + Livewire app. One module name across `app/Livewire/`, `app/Services/`, `views/livewire/`, `routes/`. Layer-first; models flat; no new layer folders. | `livewire-project-init`, `everything-modular-rbac` |
| [`everything-modular-rbac`](./everything-modular-rbac/STYLE.md) | Role-based access on top of `everything-modular`. Role folder *inside* the module (`Livewire/<Module>/<Role>/`); services never role-aware; URLs role-first, names module-first; authz only in middleware/gates/policies/`@can`. | `everything-modular` |

<!--
Add a row (or use add-codestyle):
| [`name`](./name/STYLE.md) | terse "use when…" | related idioms |
-->
