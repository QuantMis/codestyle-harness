# Checklist — laravel/everything-modular

Placement + naming only. All must be yes.

## Module shape

- [ ] Every module exists in all four locations: `app/Livewire/<Module>/`, `app/Services/<Module>/`, `resources/views/livewire/<module>/`, `routes/<module>.php` — including the empty ones (`.gitkeep` / empty route group).
- [ ] The four names are the same word, differing only in case: PascalCase under `app/`, kebab-case lowercase in views and route filename. No `Complaint/` vs `complaints/`, no `-module` / `Module` suffix.
- [ ] Every module folder names a domain capability, not a technical bucket — `grep` for `Livewire/Forms`, `Livewire/Tables`, `Livewire/Modals`, `Services/Helpers`, `Services/Traits` finds nothing.
- [ ] No service provider, config file, autoload entry, or registry added per module.

## app/ layout

- [ ] Only `app/Livewire/` and `app/Services/` contain module subfolders.
- [ ] `app/Models/` is flat — no subfolders, no `App\Models\<Module>\…` namespace.
- [ ] `app/Jobs/`, `app/Policies/`, `app/Enums/`, `app/Http/` are flat — no module subfolders.
- [ ] No new layer folder under `app/`: no `Modules/`, `Domain/`, `Repositories/`, `Support/`, and no hand-added `Actions/` (the kit's `app/Livewire/Actions/` is the only permitted one).
- [ ] `app/Services/<Module>/` is where non-component, non-model logic lives.

## The mirror

- [ ] Every `App\Livewire\<Module>\<Name>` has its view at `resources/views/livewire/<module>/<kebab-name>.blade.php`.
- [ ] Every file in `resources/views/livewire/` is owned by a component class — no orphan views.
- [ ] `grep -r "function render" app/Livewire/` finds nothing (mirror holds → no `render()`); any hit is justified in review, not absorbed.
- [ ] No `->view(…)` / `render()` pointing outside the derived path — a mismatch was fixed by renaming the class.

## Naming

- [ ] Component classes follow `List<Entities>` / `<Entity>Form` / `<Entity>Detail` where the screen is one of those three.
- [ ] `grep -r "class .*Service" app/Services/` finds nothing — services are named for the job (`SlaCalculator`, `ComplaintNumberGenerator`), not suffixed `*Service`.

## Routes

- [ ] One `routes/<module>.php` per module, each `require`d from `routes/web.php`.
- [ ] `routes/web.php` contains `require` lines and top-level view routes only — no domain route bodies.
- [ ] Full-page routes use `Route::livewire(…, Component::class)`; `grep -r "Route::get(.*::class" routes/` finds nothing.
- [ ] Route names are module-prefixed and match the folder name (`complaints.index`, not `complaint.list`).

## Views

- [ ] `resources/views/livewire/<module>/` holds Livewire component views only.
- [ ] Module-scoped Blade components live in `resources/views/components/<module>/` using the same module name.
- [ ] `layouts/`, `partials/`, `flux/` are not modularized.

## Shared

- [ ] Anything used by ≥2 modules lives in the matching `Shared/` folder — no class or partial duplicated across two modules.
- [ ] Anything used by exactly 1 module lives in that module, not in `Shared/`.
- [ ] `Shared/` holds a small set of genuinely cross-cutting concerns — 3+ unrelated concerns means a module was never named; flag it.
- [ ] Cross-module calls are direct (`use App\Services\Complaints\SlaCalculator;`) — no per-module interface, facade, or gate introduced to permit them.

## Kit legacy

- [ ] Kit-generated `app/Livewire/Auth/`, `Settings/`, `Actions/` left in place — not retrofitted with `Services/` counterparts, not renamed.
