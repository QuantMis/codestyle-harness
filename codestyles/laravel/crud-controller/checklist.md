# Checklist — laravel/crud-controller

All must be yes.

- [ ] Extends base `Controller`.
- [ ] 7 methods present, canonical order (or omissions documented).
- [ ] `Route::resource(...)`, not 7 hand-wired routes.
- [ ] Route–model binding (type-hinted params); no `find`/`findOrFail`-by-id in-method.
- [ ] Authz via `authorizeResource(...)` in constructor, not per-method.
- [ ] `store`/`update` type-hint Form Requests + `$request->validated()`; no inline `validate` / `Validator::make`.
- [ ] Return type on every method (`View` | `RedirectResponse`).
- [ ] `store`/`update`/`destroy` → redirect to named route + `->with('status', ...)`.
- [ ] No business logic / side effects / non-trivial queries in controller.
- [ ] View data via `compact()` / `->with()`; plural = collection, singular = one model.
