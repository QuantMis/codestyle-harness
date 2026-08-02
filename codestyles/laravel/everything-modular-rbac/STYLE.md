---
framework: laravel
name: everything-modular-rbac
tags: [architecture, folder-structure, modules, roles, rbac, authorization, livewire, routing, views]
use-when: Role-based access app already on `everything-modular`. Screens for one entity genuinely diverge per role (admin / technician / staff). Adding a role folder, role-prefixed URL, gate, policy, or role layout.
use-when-not: Single-role app. Roles differ only by row scope or one hidden button (→ scope the query + `@can`). Base file placement (→ `everything-modular`). Modelling roles/permissions themselves — enum vs column vs package is out of scope here.
related: [everything-modular, livewire-project-init]
---

# Laravel — Everything Modular, Role Dimension

## Intent

Delta on `everything-modular`. That idiom still places every file; this one adds the
**second axis** only.

**Module is the first axis. Role is the second.** Role folders go *inside* a module,
never above it:

```
app/Livewire/<Module>/<Role>/          resources/views/livewire/<module>/<role>/
app/Services/<Module>/                 <- no roles here, ever
routes/<module>.php                    <- role = a group inside the file
```

Why not `app/Livewire/Admin/Complaints/`: `Services/` and `Models/` have no roles —
there is no admin `SlaCalculator`. A role-first tree gets no matching `Services/Admin/`,
so the mirror dies on the first commit.

Everything `everything-modular` says still holds. Nothing below overrides it.

## Conventions

### When to split

1. Threshold: **> 2 role conditionals in one component or its view** → split into role
   folders. At or below → one component; scope the query, `@can` the controls.
2. Split is per screen, not per module. `Complaints/Admin/ListComplaints` +
   `Complaints/Staff/ListComplaints` coexist with an unsplit `Complaints/ComplaintDetail`
   in the same module. Role folders are never all-or-nothing.
3. Two role components that differ only in a query scope = premature split. Collapse back
   to one.

### Placement

4. Role folder is a **child** of the module folder: `app/Livewire/<Module>/<Role>/`.
   Never `app/Livewire/<Role>/<Module>/`, never a bare `app/Livewire/<Role>/`.
5. **Only `app/Livewire/` takes role subfolders.** `app/Services/<Module>/` never does.
   `app/Models/`, `app/Policies/`, `app/Enums/`, `app/Jobs/` stay flat — as
   `everything-modular` #5–#7 leaves them.
6. Role folder name = the app's actual role word, PascalCase under `app/`, kebab-case
   lowercase in views. `Admin` ↔ `admin`, `Technician` ↔ `technician`. No folder-only
   synonyms (`Staff/` for a role the system calls `employee`).
7. Mirror extends one level, still with zero configuration:

   | Class | View |
   |---|---|
   | `App\Livewire\Complaints\Admin\ListComplaints` | `livewire/complaints/admin/list-complaints.blade.php` |
   | `App\Livewire\Complaints\Staff\ComplaintForm` | `livewire/complaints/staff/complaint-form.blade.php` |

8. Class naming **unchanged** by the split — `List<Entities>` / `<Entity>Form` /
   `<Entity>Detail` (`everything-modular` #10). Role lives in the folder: not repeated in
   the class (`AdminListComplaints`), not replaced by a per-role verb
   (`ManageComplaints`, `AssignedComplaints`, `SubmitComplaint`).

### Routes

9. Still one file per module, `routes/<module>.php` (`everything-modular` #12). A role is
   a `prefix() + name() + middleware()` group **inside** it. Never `routes/admin.php`.
10. URLs role-first: `/admin/complaints`, `/technician/complaints`. Users read URLs.
11. Route names module-first, role second: `complaints.admin.index`,
    `complaints.technician.index`. Code reads names, and the name must match the folder
    path — `Livewire/Complaints/Admin/ListComplaints` → `complaints.admin.index`.
12. #10 vs #11 diverge deliberately. Do not "fix" it.
13. Component in a role folder → route name carries the role segment, always. Bare
    `complaints.index` / `complaints.show` is reserved for a component **not** in a role
    folder. Name ↔ folder path stays exact.
14. Coarse authorization on the group: `->middleware('can:manage-complaints')`. The group
    is the only place that check appears — no repeat of the same gate inside the
    component's methods.

### Authorization

15. Authorization lives in exactly four places. Nowhere else:
    - route-group middleware — coarse, guards the screen
    - gates — named capabilities, defined once in `AppServiceProvider::boot()`
    - policies — per model, per record
    - `@can` in blade — hides controls
16. Per-record check → `$this->authorize('assign', $complaint)` in the component action.
    Middleware guards the screen; the policy guards the row. Both, not either.
17. **No role checks in `app/Services/`.** A service taking a `$role` argument or calling
    `auth()` breaks the first time a queued job runs it with no authenticated user.
    Services take data, return data; who may call them is the component's problem.
18. Row scoping lives in the **query**, not the view. A technician sees assigned rows
    because `render()` filters `where('assigned_to', auth()->id())` — never because blade
    hides the others.
19. Role source of truth (enum | `users.role` column | permission package) is out of scope
    for this idiom. This governs *where* authorization is expressed, not how a role is
    stored.

### Views

20. `resources/views/livewire/<module>/<role>/` mirrors the class path, holds Livewire
    component views only (`everything-modular` #15).
21. Markup shared across role variants → Blade component in
    `resources/views/components/<module>/` (`everything-modular` #16). Not a role folder,
    not copied per role.
22. **Partials are role-agnostic or they are not partials.** No
    `@if (auth()->user()->isAdmin())` inside a shared partial — that is the role split
    undone in blade. A partial needing a role check belongs to one role's view.

### Layouts

23. Per-role layout only when the chrome genuinely differs (different nav, different
    shell): `layouts/admin.blade.php` beside `layouts/app.blade.php`. Selected with
    `#[Layout('layouts.admin')]` on the class.
24. Layouts stay flat in `resources/views/layouts/` (`everything-modular` #17). One
    layout per role at most. No `layouts/complaints/admin.blade.php`.

### Shared

25. `Shared/` is a module name, not a role (`everything-modular` #18). `app/Livewire/Shared/`
    may take role folders on the same rules. `app/Livewire/<Module>/Shared/` is not a
    thing — that is a Blade component under #21.

## Canonical example

`example.txt` — the `complaints` module split three ways: annotated tree, extended mirror
table, the module route file with role groups, gates, one component per role, the policy,
and a role-agnostic partial.

## Anti-patterns

- `app/Livewire/Admin/Complaints/` — role-first. No matching `Services/Admin/` exists; the
  mirror breaks immediately.
- `app/Services/Complaints/Admin/` — services never carry roles.
- `app/Livewire/Complaints/Admin/AdminListComplaints.php` — role in the folder *and* the
  class name.
- Role-verb class names (`ManageComplaints`, `AssignedComplaints`, `SubmitComplaint`)
  instead of the three default shapes.
- Splitting on one role conditional. Two near-identical components cost more than one
  `@can`.
- `routes/admin.php` — a route file per role. Files are per module; role is a group inside.
- Route name not matching the folder path: `Complaints\Staff\ListComplaints` mounted at
  `complaints.index`, or `admin.complaints.index` for `Complaints\Admin\`.
- `->middleware('can:manage-complaints')` on the group *and* `Gate::allows('manage-complaints')`
  at the top of every method in that component.
- `auth()` or a `$role` parameter anywhere under `app/Services/`.
- A shared partial containing a role check.
- Role scoping expressed in blade (`@if ($complaint->assigned_to === auth()->id())` around
  a row) instead of in the query.
- `layouts/complaints/admin.blade.php` — layouts are not modularized.
- A `Roles/` folder, `HasAdminScreens` trait, or per-role service provider — there is
  nothing to register; the folder is the whole mechanism.
