---
name: apply-codestyle
description: Use when implementing new code in a supported framework (e.g. Laravel) and it should follow this repo's established house conventions instead of ad-hoc style. Triggers when the user asks to build, add, scaffold, or refactor a feature — a CRUD flow, controller, model, request, policy, service, etc. Decomposes the task into concrete artifacts, retrieves the matching codestyle idioms from the bundled catalog, implements to spec, then verifies each artifact against its conformance checklist.
---

# Apply Codestyle

Implement new code so it matches the project's house conventions, using the bundled codestyle catalog as the source of truth. Do **not** invent style — retrieve it, then follow it.

## Where the catalog lives

The catalog is bundled with this plugin. Read it from `${CLAUDE_PLUGIN_ROOT}/codestyles/`.
If `$CLAUDE_PLUGIN_ROOT` is unset (e.g. you are running inside the `codestyle-harness` repo itself), fall back to `./codestyles/`.

Structure: `codestyles/<framework>/INDEX.md` is the catalog; each entry is a folder with `STYLE.md` (rules + intent), `example.<ext>` (canonical reference), and `checklist.md` (conformance points).

## Procedure

1. **Identify the framework.** Detect it from the current project (e.g. `composer.json` → Laravel, `package.json` → React/Next). If ambiguous, ask.

2. **Decompose the task** into the concrete artifacts to produce. For a CRUD feature in Laravel that's typically: migration, model, form request(s), controller, routes, views, and possibly a policy. List them explicitly before writing anything.

3. **Retrieve matching idioms.** Read `codestyles/<framework>/INDEX.md`. For each artifact, select the matching codestyle entry — there may be **several** for one task (e.g. `crud-controller` + `form-request` + `policy-gate`). Load each selected `STYLE.md` and its `example` file.

4. **Handle gaps.** If an artifact has **no** matching codestyle in the catalog, stop before implementing it and hand off to the `add-codestyle` skill to author the missing idiom first (or, if you cannot, flag the gap to the user and ask how to proceed). Never silently improvise a convention the catalog doesn't cover.

5. **Implement** each artifact by following its `STYLE.md` rules and mirroring the structure/naming of its `example` file, adapted to the user's model/domain. When multiple idioms apply, compose them.

6. **Verify conformance.** For every idiom you applied, walk its `checklist.md` against the code you wrote and fix any deviation. Only then consider the artifact done.

7. **Report** which codestyle idioms were applied (by name) and note any gaps that were flagged or newly authored.

## Notes

- Prefer the canonical `example` file over prose when they seem to differ — imitate the concrete example.
- Keep retrieval lean: only load the framework catalog you need, and only the entries relevant to the current artifacts.
