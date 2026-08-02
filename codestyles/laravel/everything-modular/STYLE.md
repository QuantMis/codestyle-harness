---
framework: laravel
name: everything-modular
tags: [architecture, folder-structure, modules, livewire, naming, routing, views]
use-when: Placing any file in a Laravel + Livewire app — component, view, service, route. New module, or flattening an ad-hoc tree into modules.
use-when-not: Day-0 scaffold (→ `livewire-project-init`). Inertia / API-only apps (no `resources/views/livewire`). Package repos. Sealed bounded contexts, per-module providers, module registries — this is folders, not DDD.
related: [livewire-project-init]
---

# Laravel — Everything Modular

## Intent

Folder + naming convention for Laravel + Livewire. One module name, repeated verbatim across every tree that can carry it:

```
app/Livewire/<Module>/            app/Services/<Module>/
resources/views/livewire/<module>/    routes/<module>.php

Same name in all four. Models stay flat in app/Models.
Only Livewire/ and Services/ modularize. No new layer folders under app/.
```

That is the entire convention. Hold those four lines → place any new file without asking.

Layer-first with module subfolders, **not** module-first. There is no `app/Modules/`.

## Conventions

### The module

1. Module = domain capability (`Complaints`, `Assets`, `Reports`). Never a technical bucket (`Forms/`, `Tables/`, `Modals/`, `Traits/`, `Helpers/`).
2. One module = four artifacts, created together, **always all four** — no case-by-case call:
   - `app/Livewire/<Module>/`
   - `app/Services/<Module>/`
   - `resources/views/livewire/<module>/`
   - `routes/<module>.php`

   Empty at birth is fine: `.gitkeep` in an empty `Services/<Module>/`, an empty route group in `routes/<module>.php`. Uniform shape > saved file.
3. Same word in all four. Only case convention differs — PascalCase under `app/`, kebab-case lowercase in views + route filename. `Complaints` ↔ `complaints`. Never `Complaint/` vs `complaints/`, never `AssetsModule/`.
4. Nothing to register. No service provider, no config entry, no autoload block, no module manifest. Adding a module = 3 × `mkdir` + 1 file + 1 `require` line in `web.php`.

### app/ — exactly two layers modularize

5. `app/Livewire/` and `app/Services/` take module subfolders. **Every other layer folder stays flat**, project-wide: `app/Models/`, `app/Jobs/`, `app/Policies/`, `app/Enums/`, `app/Http/`. No `app/Jobs/Complaints/`.
6. Models flat in `app/Models`. No subfolders, no per-module namespace — `App\Models\Complaint`, never `App\Models\Complaints\Complaint`.
7. No new layer folders under `app/`. Not `app/Modules/`, `app/Domain/`, `app/Repositories/`, `app/Support/`, `app/Actions/`. Anything that is not a component and not a model → `app/Services/<Module>/`.

### The mirror

8. Livewire v3+ auto-discovers `App\Livewire\*` and derives the view path from the class path. The mapping is the convention enforcing itself — nothing to configure:

   | Class | View |
   |---|---|
   | `App\Livewire\Complaints\ListComplaints` | `livewire/complaints/list-complaints.blade.php` |
   | `App\Livewire\Assets\AssetForm` | `livewire/assets/asset-form.blade.php` |

9. Mirror holds → omit `render()`. Needing `->render()` to point somewhere else means the mirror is broken: **rename the class**, don't override the path.

### Naming inside a module

10. Component classes — default shape per entity: `List<Entities>`, `<Entity>Form`, `<Entity>Detail`. Deviate when the screen isn't one of those three; don't invent a fourth synonym for one that is.
11. Services named for the job they do, **no `Service` suffix**: `ComplaintNumberGenerator`, `SlaCalculator`, `DepreciationCalculator`, `ComplaintSummaryQuery`. `ComplaintService` is banned — a class that can only be named that is doing more than one job; split it.

### Routes

12. One route file per module, `routes/<module>.php`, `require`d from `routes/web.php`. `web.php` holds requires + top-level view routes only — no domain route bodies.
13. Full-page components via `Route::livewire('path', Component::class)->name(…)`. Not `Route::get(…, Component::class)`.
14. Route names module-prefixed, matching the folder: `complaints.index`, `complaints.create`, `assets.show`.

### Views

15. `resources/views/livewire/<module>/` holds Livewire component views only — it is the mirror, and every file in it is owned by a class.
16. Module-scoped Blade partials / Blade components (≠ Livewire) → `resources/views/components/<module>/`. Same name, same kebab case.
17. App-level views are not modularized — `layouts/`, `partials/`, `flux/` stay as the kit ships them.

### Shared

18. `Shared/` is a reserved module name in every modularized location: `app/Livewire/Shared/`, `app/Services/Shared/`, `resources/views/livewire/shared/`, `resources/views/components/shared/`.
19. Promote on the second consumer. Used by 1 module → stays in that module. Used by ≥2 → move to `Shared/`. Never copy.
20. Modules are folders, not bounded contexts. `Livewire\Assets\AssetForm` may call `Services\Complaints\SlaCalculator` directly — no interface, no facade, no cross-module gate. Two modules reaching for the same class is not a violation; it is the trigger for #19.

### Kit legacy

21. Kit-generated folders (`app/Livewire/Auth/`, `app/Livewire/Settings/`, `app/Livewire/Actions/`) predate your modules. Leave them — #2 and #7 are not applied retroactively to kit output. `Actions/` is a technical bucket and is the one standing exception, because it is the kit's. New code follows the convention.

## Canonical example

`example.txt` — three modules (`complaints`, `assets`, `reports`) end to end: annotated tree, the mirror table, `web.php` + a module route file, and the `Shared/` promotion.

## Anti-patterns

- `app/Modules/Complaints/{Livewire,Services,Views}` — module-first. This convention is layer-first; the module is the subfolder, never the parent.
- Any new layer folder under `app/`: `app/Domain/`, `app/Repositories/`, `app/Support/`, `app/Actions/`.
- Modularizing a flat layer: `app/Models/Complaints/`, `app/Jobs/Complaints/`, `app/Policies/Complaints/`.
- Technical buckets as module names — `Livewire/Forms/`, `Livewire/Tables/`, `Services/Helpers/`.
- Name drift across the four locations: `app/Livewire/Complaints/` + `views/livewire/complaint/`, or `routes/complaint-routes.php`.
- `->render()` pointing outside the mirror, instead of renaming the class.
- Skipping `Services/<Module>/` "because it's empty" → next person has to decide where the first service goes.
- `*Service` suffix (`ComplaintService`, `AssetService`).
- Same helper copied into two modules instead of promoted to `Shared/`.
- `Shared/` used as a dumping ground for a module nobody named — 3+ unrelated concerns in `Shared/` = a missed module boundary.
- All routes in `web.php`; or `Route::get('/complaints', ListComplaints::class)`.
- A service provider, config file, or registry per module — there is nothing to register.
