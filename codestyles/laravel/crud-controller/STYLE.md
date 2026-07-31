---
framework: laravel
name: crud-controller
tags: [controller, crud, resource, blade]
use-when: Resourceful CRUD for an Eloquent model, rendering Blade views.
use-when-not: JSON/API controllers (→ `api-resource`), invokable/single-action controllers, domain workflows (→ service/action class).
related: [form-request, policy-gate]
---

# Laravel — CRUD Controller

## Intent

Thin resourceful controller. Maps 7 REST actions to an Eloquent model. Validation → Form Requests, authz → Policy. Orchestrates only — no business rules.

## Conventions

1. Extend base `Controller`. All 7 methods, canonical order: `index`, `create`, `store`, `show`, `edit`, `update`, `destroy`.
2. Register via `Route::resource(...)` — never hand-wire the 7 routes.
3. Route–model binding: type-hint model in signature (`show(Post $post)`). No `find($id)` in-method.
4. Authz once: `authorizeResource(Model::class, 'param')` in constructor (pairs with `policy-gate`). No per-method gate checks.
5. Validate via Form Requests (`Store*Request`, `Update*Request`). `store`/`update` type-hint them + `$request->validated()`. No inline `validate([...])`, no `Validator::make`.
6. Return type on every method (`View` | `RedirectResponse`).
7. `store`/`update`/`destroy` → redirect to named route + `->with('status', ...)` flash. Never return a view from a write.
8. View data via `compact()` / `->with()`. Plural = collection (`$posts`), singular = one model (`$post`).
9. Queries fluent + minimal (`Model::query()->latest()->paginate()`). Non-trivial → model scope / query class.
10. No business logic, no side effects beyond persist + redirect. Grows → extract action/service.

## Canonical example

`example.php` — `PostController` for a `Post` model.

## Anti-patterns

- Fat controller: validation / authz / business rules inline.
- `find($id)` / `findOrFail($id)` over route–model binding.
- View from `store`/`update`/`destroy` — breaks POST-redirect-GET, resubmits on refresh.
- Missing return types, methods out of order.
- This idiom for JSON APIs — use `api-resource`.
