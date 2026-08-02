---
framework: laravel
name: livewire-project-init
tags: [scaffold, project-init, livewire, starter-kit, tooling, ci]
use-when: Day-0 scaffold of a new Laravel + Livewire app — install command, directory skeleton, quality-gate baseline.
use-when-not: App already scaffolded (never re-scaffold). Component authoring / state / validation / CRUD conventions (→ separate idioms). Inertia (React/Vue) or API-only frontends. Package/plugin repos.
related: [crud-controller]
---

# Laravel — Livewire Project Init

## Intent

Day-0 skeleton only. One install command → class-based Livewire tree + quality gates green on commit 1. Adopts what the official kit already ships (Pint, Larastan, Pest, CI) rather than reinventing it; adds exactly two things the kit lacks (strict types, pre-commit hook). Stops at the skeleton — component authoring, domain layering, CRUD → other idioms.

Stack the kit resolves to (verified 2026-08): Laravel 13 · Livewire 4 · Flux UI 2 · Tailwind 4 · Vite 8 · Pest 5 · Larastan 3 · PHP ≥8.3. Pin nothing by hand — take the kit's resolution.

## Conventions

1. One bootstrap command, official kit, non-interactive:
   `laravel new <app> --livewire --livewire-class-components --pest --git --npm --database=<driver>`
   No bare skeleton + `composer require livewire/livewire`. No Breeze. No community `--using=` kit.
2. `--livewire-class-components` is mandatory, not taste. Livewire 4 defaults to single-file components (`⚡*.blade.php`) — the flag is what selects class components. After init: `php artisan make:livewire <Name> --class`. Never `--mfc`, never SFC, never Volt.
3. Component ↔ view mirror 1:1 — `app/Livewire/<Domain>/<Name>.php` (ns `App\Livewire\<Domain>`) ↔ `resources/views/livewire/<domain>/<kebab-name>.blade.php`. Mirror holds → omit `render()`.
4. `app/Livewire/` subfolders = domain capabilities (`Settings/`, `Billing/`), never technical buckets (`Forms/`, `Tables/`, `Components/`).
5. Full-page routes via `Route::livewire('path', Component::class)->name('…')` — not `Route::get(…, Component::class)`. Split route files per domain, `require`d from `routes/web.php` (kit precedent: `routes/settings.php`).
6. Commit 1 = untouched kit output (`--git` produces it). Every deviation lands in later commits → next kit upgrade stays diffable.
7. Kit gates adopted as-is — never reinvented, never deleted: `pint.json`, `phpstan.neon` (Larastan, `level: 7`, paths `app/ bootstrap/app.php config/ database/ routes/`), `.github/workflows/tests.yml`, `.github/dependabot.yml`. Stan level ratchets up only.
8. Exactly two tooling deltas at init — `pint.json` += `"rules": {"declare_strict_types": true}`, and `.githooks/pre-commit`. Anything further → later commit, with a reason.
9. Strict types via Pint, not by hand: after the `pint.json` delta run `composer lint` once → normalizes every PHP file; land it as its own commit. No hand-typed `declare(strict_types=1);`, no per-file exemptions.
10. Strict types breaks Larastan on the kit's own code — fix the annotation, don't suppress. `strict_types=1` kills `Stringable`→`string` coercion, so `app/Concerns/ProfileValidationRules.php` fails level 7 (`Rule::unique()` returns `Illuminate\Validation\Rules\Unique implements Stringable`, not `ValidationRule`). Name the concrete rule class in the `@return` union — the kit's own `PasswordValidationRules` already does this with `Password`. Never `@phpstan-ignore`, never a baseline, never a level drop.
11. Pre-commit hook committed at `.githooks/pre-commit` (`composer lint` + `composer types:check`). Wire via `git config core.hooksPath .githooks`, exposed as composer script `hooks:install`, appended to `setup`. Never `.git/hooks`-only — uncommitted = unshared.
12. Gates invoked through composer scripts only — `lint`, `lint:check`, `types:check`, `test`, `ci:check`, `setup`, `dev`. No raw `vendor/bin/pint|phpstan|pest` in CI, hooks, docs, or README.
13. Pest only (`--pest`). `tests/Pest.php` binds `Tests\TestCase` (+ `RefreshDatabase` for `Feature`). No PHPUnit-style `class *Test extends TestCase`.
14. Committed vs not: `.env.example` committed and carries every key the app reads; `.env` never. SQLite file stays covered by `database/.gitignore` (`*.sqlite*`) — never force-add.
15. Frontend stays kit default — Flux UI + Tailwind 4 (`@tailwindcss/vite`) + Vite. No second CSS framework, bundler, or component library at init.
16. Init is done only when `composer ci:check` is green on a clean clone. Not "scaffolded" — green.

## Canonical example

`example.txt` — init sequence, annotated skeleton tree, and the two delta files verbatim.

## Anti-patterns

- `composer require livewire/livewire` onto a bare `laravel new` — hand-wired layout/auth/Tailwind, off the kit upgrade path.
- Omitting `--livewire-class-components`, then hand-converting the SFC tree.
- Volt / `--mfc` / SFC mixed into a class-component project.
- `Route::get('/x', Component::class)` for full pages.
- Lowering `phpstan.neon` level — or excluding `app/Livewire` — to make init green.
- Deleting `.github/workflows/tests.yml` "until the project is real".
- Hand-typing `declare(strict_types=1)` per file instead of the Pint rule.
- Hook in `.git/hooks` only → nobody else runs it.
- `vendor/bin/pint --test` in CI instead of `composer lint:check` → two sources of truth.
- Absorbing the strict-types fallout with `@phpstan-ignore` / a baseline / `level: 5` instead of correcting the `@return` union.
- Editing kit files before commit 1 → upgrade diff unreadable forever.
- `.env` committed; `database/database.sqlite` force-added.
- Calling init "done" at `laravel new` while `composer ci:check` is still red.
