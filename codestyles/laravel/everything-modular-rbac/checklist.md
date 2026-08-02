# Checklist — laravel/everything-modular-rbac

Role axis only. `everything-modular`'s checklist still applies in full — run both.
All must be yes.

## The split

- [ ] Every role folder exists because the screen had > 2 role conditionals — not because the module has roles.
- [ ] No two role components differ only by a query scope or a hidden button; such pairs were collapsed to one component + `@can`.
- [ ] Unsplit components still live directly under the module folder — role folders were not forced onto every screen in the module.

## Placement

- [ ] Every role folder is a child of a module folder: `app/Livewire/<Module>/<Role>/`.
- [ ] No top-level role folder — `app/Livewire/Admin/`, `app/Livewire/Staff/` do not exist.
- [ ] `app/Services/` contains zero role folders: `find app/Services -type d` returns module names only.
- [ ] `app/Models/`, `app/Policies/`, `app/Enums/`, `app/Jobs/` still flat — no role subfolders.
- [ ] Role folder names match the app's real role vocabulary, PascalCase under `app/`, kebab-case lowercase under `views/`.

## The mirror

- [ ] Every `App\Livewire\<Module>\<Role>\<Name>` has its view at `resources/views/livewire/<module>/<role>/<kebab-name>.blade.php`.
- [ ] No component renders another role's view; no `->view(…)` crossing a role folder.
- [ ] Every file under `resources/views/livewire/<module>/<role>/` is owned by a component class.

## Naming

- [ ] Class names inside role folders are still `List<Entities>` / `<Entity>Form` / `<Entity>Detail`.
- [ ] No role word inside a class name — `grep -rE "class (Admin|Staff|Technician)" app/Livewire/` finds nothing.
- [ ] No per-role verb classes (`ManageComplaints`, `AssignedComplaints`, `SubmitComplaint`, `MyComplaints`).

## Routes

- [ ] One route file per module. `ls routes/` shows no role-named file (`admin.php`, `staff.php`).
- [ ] Each role is a `prefix() + name() + middleware()` group inside its module's route file.
- [ ] URLs are role-first (`/admin/complaints`), route names are module-first (`complaints.admin.index`).
- [ ] Every route name matches its component's folder path — a component in `<Module>/<Role>/` has a `<module>.<role>.` name; a component outside a role folder does not.
- [ ] Coarse gate appears once, on the route group — not repeated inside the component's methods.

## Authorization

- [ ] Authorization appears only in route middleware, gates, policies, and `@can` — nowhere else.
- [ ] Every write/state-changing component action calls `$this->authorize(…)` for its record.
- [ ] `grep -rE "auth\(\)|\\\$role" app/Services/` finds nothing.
- [ ] No service method takes a role or user-role parameter.
- [ ] Row scoping is in the query (`where(…)` in the component), not in blade — no `@if` around a row to hide it from a role.

## Views

- [ ] Markup shared by ≥2 role views lives in `resources/views/components/<module>/`, not duplicated per role folder.
- [ ] `grep -rE "auth\(\)->user\(\)->|hasRole|isAdmin" resources/views/components/` finds nothing — shared partials are role-agnostic.
- [ ] No `resources/views/livewire/<module>/<role>/partials/` folder.

## Layouts

- [ ] Role layouts, if any, are flat in `resources/views/layouts/` — at most one per role.
- [ ] Layout selected via `#[Layout('layouts.<role>')]` on the component class, not inside the view.
- [ ] No `resources/views/layouts/<module>/` folder.

## Nothing registered

- [ ] No per-role service provider, config entry, trait (`HasAdminScreens`), or registry — the folder is the whole mechanism.
