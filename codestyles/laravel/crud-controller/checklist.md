# Conformance checklist — laravel/crud-controller

Answer each yes/no against the candidate controller. Every point must be **yes**.

- [ ] Controller extends the base `Controller`.
- [ ] All seven resourceful methods are present, in canonical order (`index`, `create`, `store`, `show`, `edit`, `update`, `destroy`) — or the intentionally-omitted ones are documented.
- [ ] Registered via `Route::resource(...)`, not seven hand-wired routes.
- [ ] Models are resolved by route–model binding (type-hinted params), with no `find`/`findOrFail` by id inside methods.
- [ ] Authorization is done once via `authorizeResource(...)` in the constructor, not per-method gate checks.
- [ ] `store` and `update` type-hint Form Request classes and use `$request->validated()`; no inline `validate([...])` or `Validator::make`.
- [ ] Every method declares a return type (`View` or `RedirectResponse`).
- [ ] `store`/`update`/`destroy` return a redirect to a named route with a `->with('status', ...)` flash message.
- [ ] No business logic, external side effects, or non-trivial query building lives in the controller.
- [ ] View data is passed with `compact()`/`->with()`, using plural names for collections and singular for a single model.
