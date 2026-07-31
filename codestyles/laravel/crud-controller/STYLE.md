---
framework: laravel
name: crud-controller
tags: [controller, crud, resource, blade]
use-when: Building standard resourceful CRUD endpoints for an Eloquent model that render Blade views.
use-when-not: JSON/API controllers returning API Resources (see `api-resource`), single-action/invokable controllers, or complex domain workflows that belong in a service or action class.
related: [form-request, policy-gate]
---

# Laravel — CRUD Controller

## Intent

A thin, resourceful controller that maps the seven standard RESTful actions to an Eloquent model, delegating validation to Form Requests and authorization to a Policy. Controllers orchestrate; they do not hold business rules.

## Conventions

1. Extend the base `Controller` and declare all seven resourceful methods in canonical order: `index`, `create`, `store`, `show`, `edit`, `update`, `destroy`.
2. Register with `Route::resource('posts', PostController::class)` — do not hand-wire the seven routes.
3. Use **route–model binding**: type-hint the model in method signatures (`show(Post $post)`), never `find($id)` inside the method.
4. Authorize with `$this->authorizeResource(Model::class, 'param')` in the constructor (pairs with the `policy-gate` idiom). Do not sprinkle `Gate::allows` checks in each method.
5. Validate via **Form Requests** (`StorePostRequest`, `UpdatePostRequest`) — the `store`/`update` signatures type-hint them and use `$request->validated()`. No `$request->validate([...])` inline, no manual `Validator::make`.
6. Add a **return type** to every method (`View` or `RedirectResponse`).
7. `store`/`update`/`destroy` return a **redirect** to a named route with a flash message via `->with('status', ...)`. Never return a view directly from a write action.
8. Pass data to views with `compact()` or `view()->with()`; keep variable names plural for collections (`$posts`) and singular for one model (`$post`).
9. Keep query logic minimal and fluent (`Model::query()->latest()->paginate()`); anything non-trivial moves to the model (scope) or a query/service class — not the controller.
10. No business logic, no side effects beyond persistence + redirect. If it grows, extract an action/service class.

## Canonical example

See [`example.php`](./example.php) — a `PostController` for a `Post` model.

## Anti-patterns

- Fat controllers holding validation rules, authorization logic, or business rules inline.
- `find($id)` / `findOrFail($id)` instead of route–model binding.
- Returning views from `store`/`update`/`destroy` instead of redirecting (breaks POST-redirect-GET, re-submits on refresh).
- Missing return types or out-of-order methods.
- Reaching for this idiom for JSON APIs — use the `api-resource` idiom instead.
