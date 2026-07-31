# Laravel — Codestyle Catalog

Catalog of Laravel codestyle idioms. The `apply-codestyle` skill reads this file to select which idioms to load for a task. Keep one row per idiom.

| Idiom | Use when | Related |
|-------|----------|---------|
| [`crud-controller`](./crud-controller/STYLE.md) | Building standard resourceful CRUD endpoints (index/create/store/show/edit/update/destroy) for an Eloquent model, rendering Blade views. | `form-request`, `policy-gate` |

<!--
To add a row, use the add-codestyle skill (or copy the format above):
| [`name`](./name/STYLE.md) | one-line "use when…" | comma-separated related idioms |
-->
