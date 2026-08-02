---
name: apply-codestyle
description: Use when implementing new code in a supported framework (e.g. Laravel) and it should follow this repo's established house conventions instead of ad-hoc style. Triggers when the user asks to build, add, scaffold, or refactor a feature — a CRUD flow, controller, model, request, policy, service, etc. Decomposes the task into concrete artifacts, retrieves the matching codestyle idioms from the bundled catalog, implements to spec, verifies each artifact against its conformance checklist, then records the applied idioms in the project's enforcement note so later work inherits them.
---

# Apply Codestyle

Implement new code so it matches the project's house conventions, using the bundled codestyle catalog as the source of truth. Do **not** invent style — retrieve it, then follow it.

## Where the catalog lives

The catalog is bundled with this plugin. Read it from `${CLAUDE_PLUGIN_ROOT}/codestyles/`.
If `$CLAUDE_PLUGIN_ROOT` is unset (e.g. you are running inside the `codestyle-harness` repo itself), fall back to `./codestyles/`.

Structure: `codestyles/<framework>/INDEX.md` is the catalog; each entry is a folder with `STYLE.md` (rules + intent), `example.<ext>` (canonical reference), and `checklist.md` (conformance points).

## Procedure

0. **Read the enforcement note.** If `./.claude/codestyle.md` exists, the idioms it lists are already **in force** for this project. Binding for this task too — don't re-litigate the choice, don't pick a competing idiom. Load their `STYLE.md` alongside whatever step 3 selects.

1. **Identify the framework.** Detect it from the current project (e.g. `composer.json` → Laravel, `package.json` → React/Next). If ambiguous, ask.

2. **Decompose the task** into the concrete artifacts to produce. For a CRUD feature in Laravel that's typically: migration, model, form request(s), controller, routes, views, and possibly a policy. List them explicitly before writing anything.

3. **Retrieve matching idioms.** Read `codestyles/<framework>/INDEX.md`. For each artifact, select the matching codestyle entry — there may be **several** for one task (e.g. `crud-controller` + `form-request` + `policy-gate`). Load each selected `STYLE.md` and its `example` file.

4. **Handle gaps.** If an artifact has **no** matching codestyle in the catalog, stop before implementing it and communicate with the author, list down the unmatched artifact and decide either proceed via adhoc codestyle from claude or plan a codestyle update?

5. **Implement** each artifact by following its `STYLE.md` rules and mirroring the structure/naming of its `example` file, adapted to the user's model/domain. When multiple idioms apply, compose them.

6. **Verify conformance.** For every idiom you applied, walk its `checklist.md` against the code you wrote and fix any deviation. Only then consider the artifact done.

7. **Record enforcement** — see below. Every idiom that passed step 6 goes into the project's note.

8. **Report** which codestyle idioms were applied (by name) and note any gaps that were flagged or newly authored.

## Recording enforcement

Codestyle only sticks if the *next* session knows about it — one that may never fire this skill. So after verifying, register the idioms in the project itself.

**Two files, both in the consuming project (never in the catalog):**

1. `./.claude/codestyle.md` — the note. Create or merge.
2. `./CLAUDE.md` — must contain the line `@.claude/codestyle.md`. Append it if missing (create `CLAUDE.md` with just that line if absent). Never add it twice.

**Rules for the note:**

- **Pointer, not a copy.** Names + scope + where to read. Never restate an idiom's rules — the catalog is the single source of truth, and a copied rule goes stale silently.
- **Merge, never clobber.** Re-running adds rows for new idioms; existing rows stay. Preserve anything a human added below the table.
- Group rows by framework. One row per idiom.
- Scope = terse "what this governs", lifted from the idiom's `use-when` / INDEX row.

**Template:**

```markdown
<!-- managed by codestyle-harness · apply-codestyle -->

# Codestyle — enforced

This project follows the **codestyle-harness** catalog. The idioms below are binding for all new + edited code.

Rules are **not** duplicated here. Before writing code in a listed scope, load the idiom from the plugin: run the `apply-codestyle` skill, or read `${CLAUDE_PLUGIN_ROOT}/codestyles/<framework>/<idiom>/` directly — `STYLE.md` (rules) → `example.*` (imitate) → `checklist.md` (verify after).

Never infer the convention from surrounding code. Read the source. Task conflicts with an idiom → flag it, don't silently deviate.

## laravel

| Idiom | Governs | Read |
|---|---|---|
| `everything-modular` | file placement + naming, repo-wide | `codestyles/laravel/everything-modular/` |
```

## Notes

- Prefer the canonical `example` file over prose when they seem to differ — imitate the concrete example.
- Keep retrieval lean: only load the framework catalog you need, and only the entries relevant to the current artifacts.
