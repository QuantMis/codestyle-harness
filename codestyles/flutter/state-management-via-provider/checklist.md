# Checklist — flutter/state-management-via-provider

All must be yes.

- [ ] State class extends `ChangeNotifier`, named `*ViewModel`, in `features/<feature>/logic/providers/`, filename snake_case matching class.
- [ ] Fields private; exposed only via read-only getters (no public mutable fields / setters).
- [ ] All mutation via public methods; every mutation path ends with `notifyListeners()`; no `notifyListeners()` in UI.
- [ ] No `BuildContext`, widgets, or material imports in the VM; depends on `data/`, not `presentation/`.
- [ ] Async status surfaced explicitly (status enum/flag + error), set around each `await`.
- [ ] Registered via `ChangeNotifierProvider(create: …)`; `.value` only for an already-existing instance.
- [ ] Feature-local VMs registered above the feature subtree; only app-wide VMs in root `MultiProvider`.
- [ ] UI listens via `Consumer<T>` / `Selector<T,S>` — no `context.watch` / `Provider.of(listen: true)`; `Selector` used for single-field watches.
- [ ] Callbacks fire actions via `context.read<T>().method()`; UI never mutates VM fields.
- [ ] `dispose()` overridden when the VM owns controllers/streams; `super.dispose()` called last.
