---
framework: flutter
name: state-management-via-provider
tags: [state-management, provider, change-notifier, view-model, logic-layer]
use-when: Feature state/logic via `provider` + `ChangeNotifier`. Fills the `logic/` layer of `feature-driven-design-architecture`.
use-when-not: bloc/cubit-based logic (→ separate idiom). Server-cache/async-data-heavy flows (→ dedicated data lib). Ephemeral single-widget state (use `StatefulWidget` + `setState`).
related: [feature-driven-design-architecture]
---

# Flutter — State Management via Provider

## Intent

Feature logic in a `ChangeNotifier` view-model, registered with `provider`, consumed via `Consumer` / `Selector`. Encapsulated state + method-driven mutation + explicit async status. Populates the `logic/providers/` folder the FDD skeleton leaves empty.

> Naming: class = `*ViewModel` (what it is); folder = `logic/providers/` (how it's registered). File snake_case matches class → `auth_view_model.dart` holds `AuthViewModel`.

## Conventions

**Create the state class**

1. State class = `ChangeNotifier` subclass, named `*ViewModel` (`AuthViewModel`). One public class per file, snake_case filename matching (`auth_view_model.dart`). Lives in `features/<feature>/logic/providers/`.
2. Encapsulate: private fields (`_user`), read-only getters (`User? get user => _user`). No public mutable fields, no setters. UI never sees mutable state.
3. Mutate only via public methods; every mutation path ends with `notifyListeners()`. No `notifyListeners()` in widgets.
4. No `BuildContext`, no widgets, no `package:flutter/material.dart` in the VM (`package:flutter/foundation.dart` for `ChangeNotifier` is fine). Depends on `data/` (repositories/models), never on `presentation/`.
5. Surface async status explicitly — status enum (`idle|loading|success|error`) or flag + error field, set before/after each `await`. Don't leak raw `Future`s to the UI.

**Register the provider**

6. Register via `ChangeNotifierProvider(create: (_) => AuthViewModel(...))` — `create:` owns + auto-disposes the instance. `.value` only to re-provide an already-existing instance; never `.value: FooViewModel()` (no auto-dispose → leak).
7. Scope: feature-local VMs registered above the feature's subtree/route; only app-wide VMs in the root `MultiProvider` (in `app.dart`). Group multiples with `MultiProvider`.

**Consume + update**

8. Listen via `Consumer<T>` (subtree rebuild) or `Selector<T, S>` (rebuild only when the selected field changes). Prefer `Selector` when watching one field of a large VM. No `context.watch` / `Provider.of(listen: true)` (house rule → builder widgets).
9. Fire actions from callbacks via `context.read<T>().method()`. Never `Consumer`/`watch` just to call a method; never mutate VM fields from the UI.

**Dispose**

10. Override `dispose()` in the VM to release owned controllers/streams/subscriptions; call `super.dispose()` last. `create:` handles the VM's own disposal.

## Canonical example

`example.dart` — composite of 3 files (VM + root registration + feature route/screen) for an `authentication` feature.

## Anti-patterns

- `notifyListeners()` called from a widget.
- Public mutable fields / setters on the VM; UI mutating state directly.
- `context.watch` / `Provider.of(listen: true)` in a callback → rebuild storms / errors.
- `context.read` in `build` for a value you render → won't rebuild.
- `BuildContext`, widgets, or material imports inside the VM.
- Everything registered globally at root (defeats feature scoping); `.value` + fresh instance (no auto-dispose → leak).
- `Consumer` around a whole screen when one field drives one widget (use `Selector`).
- Business logic / repository calls in the widget instead of the VM.
