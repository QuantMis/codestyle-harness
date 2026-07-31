---
name: add-codestyle
description: Use when a needed convention is missing from the codestyle catalog, or the user wants to capture, author, or extract a new codestyle idiom into this repo. Run this while working inside the codestyle-harness repository itself. Guides a short discussion to define the pattern (intent, rules, when-to-use, anti-patterns), then writes a new STYLE.md + canonical example + conformance checklist under codestyles/<framework>/ and updates that framework's INDEX.
---

# Add Codestyle

Capture a new codestyle idiom into this repo's catalog. This skill **writes** to the catalog, so it is meant to be run while working *inside the `codestyle-harness` repo* (development mode). Target `./codestyles/` — not `${CLAUDE_PLUGIN_ROOT}`.

## Procedure

1. **Scope the idiom.** Establish:
   - **framework** (e.g. `laravel`) and a short kebab-case **name** (e.g. `comparator-class`).
   - **intent** — what problem this pattern solves.
   - **use-when** and **use-when-not** — the boundaries.
   - **related** idioms it composes with.

2. **Source the canonical example.** Either:
   - discuss and write a fresh, idiomatic reference implementation with the user, or
   - extract one from an exemplar file the user points to (copy the *shape*, strip domain specifics down to a clear representative case).

3. **Create the folder** `codestyles/<framework>/<name>/` with three files:
   - `STYLE.md` — frontmatter (`framework`, `name`, `tags`, `use-when`, `use-when-not`, `related`) + sections: Intent, Conventions (numbered rules), Canonical example (points to the example file), Anti-patterns.
   - `example.<ext>` — the canonical reference implementation.
   - `checklist.md` — a bullet list of objectively verifiable conformance points (each phrased so it can be answered yes/no against a candidate implementation).

4. **Update the index.** Add a one-line row for the new idiom to `codestyles/<framework>/INDEX.md`. If the framework is new, create the folder and a fresh `INDEX.md` from the existing one's format.

5. **Confirm** the new files back to the user, and remind them to commit + push so consumers pick it up via `/plugin update`.

## Writing style (house rule)

All catalog prose you write — `STYLE.md`, `checklist.md`, `INDEX.md` rows, frontmatter `use-when` / `use-when-not` — is **terse/telegraphic**. Sacrifice grammar for concision:

- Fragments over sentences. Drop articles and linking verbs.
- `→` for sequences/consequences; `|` for "or"; `≠` etc. where it saves words.
- Symbols/code over prose (`no per-method gate checks`, not "you should avoid checking the gate in each method").
- Terse ≠ vague — rules stay concrete and checkable. Cut words, not specifics.
- Match the existing idioms in tone (see `codestyles/laravel/crud-controller/`).

The generated *code* still follows the idiom's own rules — this concision rule governs the catalog docs, not the code output.

## Quality bar

- Rules must be concrete and checkable, not vibes ("constructor injection for deps", not "write clean code").
- The example must actually satisfy every point in its own checklist — verify before finishing.
- Keep each idiom single-purpose. Two patterns in one discussion → author two idioms, cross-link via `related`.
