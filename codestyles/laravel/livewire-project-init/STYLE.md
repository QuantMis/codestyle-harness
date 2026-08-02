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

Day-0 skeleton only. One install command → class-based Livewire tree + quality gates green on commit 1. Adopts what the official kit already ships (Pint, Larastan, Pest, CI) rather than reinventing it; adds exactly one mandatory delta the kit lacks (a committed pre-commit hook). Stops at the skeleton — component authoring, domain layering, CRUD → other idioms.

**Init is DB-independent.** It scaffolds on SQLite and finishes green with no database server running. Choosing a real driver (MySQL/Postgres) is Stage 3 — a separate provisioning milestone, not part of init.

Stack the kit resolves to (verified 2026-08): Laravel 13 · Livewire 4 · Flux UI 2 · Tailwind 4 · Vite 8 · Pest 5 · Larastan 3 · PHP ≥8.3. Pin nothing by hand — take the kit's resolution.

## Stages

| Stage | Scope | Done when |
|-------|-------|-----------|
| 1 — Bootstrap | `laravel new` → commit 1 = untouched kit output | Kit tree exists, committed unmodified |
| 2 — Init (this idiom) | Pre-commit hook, gate wiring, `.env` repair | `composer install` + static gates green + Pest green on SQLite |
| 3 — Provisioning (separate) | Real DB driver, migrations against a server, CI DB service | Out of scope here |

## Conventions

### Bootstrap

1. One bootstrap command, official kit, non-interactive, run **from the parent directory**:
   ```
   export APP_URL=http://localhost:8000
   laravel new <app> --livewire --livewire-class-components --pest --git --npm --database=sqlite
   ```
   No bare skeleton + `composer require livewire/livewire`. No Breeze. No community `--using=` kit.
   The `export` is not optional — see §Environment. Add `--force` if the target directory already exists, even when empty.
2. `--database=sqlite` is the init default, not a placeholder. It makes the installer's internal `migrate` a zero-dependency file touch, and lets `RefreshDatabase` and the whole suite run green with no external server. Other drivers are Stage 3.
3. `--livewire-class-components` is mandatory, not taste. Livewire 4 defaults to single-file components (`⚡*.blade.php`) — the flag is what selects class components. After init: `php artisan make:livewire <Name> --class`. Never `--mfc`, never SFC, never Volt.
4. Commit 1 = untouched kit output (`--git` produces it). Every deviation lands in later commits → next kit upgrade stays diffable.

### Structure

5. Component ↔ view mirror 1:1 — `app/Livewire/<Domain>/<Name>.php` (ns `App\Livewire\<Domain>`) ↔ `resources/views/livewire/<domain>/<kebab-name>.blade.php`. Mirror holds → omit `render()`.
6. `app/Livewire/` subfolders = domain capabilities (`Settings/`, `Billing/`), never technical buckets (`Forms/`, `Tables/`, `Components/`).
7. Full-page routes via `Route::livewire('path', Component::class)->name('…')` — not `Route::get(…, Component::class)`. Split route files per domain, `require`d from `routes/web.php` (kit precedent: `routes/settings.php`).

### Gates

8. Kit gates adopted as-is — never reinvented, never deleted: `pint.json`, `phpstan.neon` (Larastan, `level: 7`, paths `app/ bootstrap/app.php config/ database/ routes/`), `.github/workflows/tests.yml`, `.github/dependabot.yml`. Stan level ratchets up only.
9. **Keep PHPStan.** It is kit-shipped, free, and DB-independent — Larastan boots the app but touches no database. Removing it fights the kit and destroys the diffable baseline. If it misbehaves, the fix is environmental (§Environment), not deletion.
10. Exactly one *mandatory* tooling delta at init: `.githooks/pre-commit`. Anything further → later commit, with a reason.
11. Pre-commit hook committed at `.githooks/pre-commit` (`composer lint` + `composer types:check`). Wire via `git config core.hooksPath .githooks`, exposed as composer script `hooks:install`, appended to `setup`. Never `.git/hooks`-only — uncommitted = unshared.
12. Gates invoked through composer scripts only — `lint`, `lint:check`, `types:check`, `test`, `ci:check`, `setup`, `dev`. No raw `vendor/bin/pint|phpstan|pest` in CI, hooks, docs, or README.

### Strict types — optional, deferrable

13. `declare_strict_types` via Pint is an **optional delta, deferred by default**. It is a real improvement but it is the single largest source of init friction: it breaks Larastan level 7 on the kit's own code (§14) and widens commit 1's diff. Adopt it when the team wants it — as its own commit, at any point — not as a gate on calling init done.
14. If you do adopt it: strict types via Pint, never by hand. Add `"rules": {"declare_strict_types": true}` to `pint.json`, run `composer lint` once → normalizes every PHP file; land it as its own commit. No hand-typed `declare(strict_types=1);`, no per-file exemptions.
15. Adopting it obliges you to take the Larastan fallout fix in the same commit. `strict_types=1` kills `Stringable`→`string` coercion, so `app/Concerns/ProfileValidationRules.php` fails level 7 (`Rule::unique()` returns `Illuminate\Validation\Rules\Unique implements Stringable`, not `ValidationRule`). Name the concrete rule class in the `@return` union — the kit's own `PasswordValidationRules` already does this with `Password`. Never `@phpstan-ignore`, never a baseline, never a level drop. Half-adopting (rule on, fallout unfixed) is worse than not adopting.

### Tests

16. Pest is the **test runner**, selected with `--pest`. It is not a syntax mandate and `--pest` is not a converter. The current kit ships PHPUnit-style `class *Test extends TestCase` files; they run green under Pest as shipped. Do not hand-convert them — that is unnecessary work, off the kit's upgrade path, and directly contradicts conventions #4 and #8.
17. `tests/Pest.php` binds `Tests\TestCase` (+ `RefreshDatabase` for `Feature`) — kit-generated, leave it. Write *new* tests in Pest's function style; leave kit tests alone.

### Frontend

18. **Flux UI ships with the kit and is not swappable.** `--livewire` pulls in `livewire/flux`; ~26 kit view files consume `<flux:*>` components. There is no official Flux-free Livewire kit, so "kit-faithful" and "Flux-free" are mutually exclusive — pick one knowingly. This idiom picks kit-faithful. Flux has a free tier and a paid Pro tier; anyone adopting this idiom is adopting that dependency and should be told so before running the command, not after.
19. Frontend otherwise stays kit default — Tailwind 4 (`@tailwindcss/vite`) + Vite. No second CSS framework, bundler, or component library at init.

### Repo hygiene

20. Committed vs not: `.env.example` committed and carries every key the app reads; `.env` never. SQLite file stays covered by `database/.gitignore` (`*.sqlite*`) — never force-add.
21. Repair `.env`'s `APP_URL` before the first commit of deviations — the installer writes it malformed (§Environment). Revert the installer's stray `composer.json` trailing-newline removal at the same time.

### Done

22. Init is done when, on a clean clone with **no database server running**:
    - `composer install` succeeds,
    - `composer lint:check` and `composer types:check` are green,
    - `composer test` is green on SQLite (expect 33 passed).

    Not "scaffolded" — green. Note this is deliberately *not* `composer ci:check` if your `ci:check` shells out to a provisioned database; keep init's definition of done free of any external service.
23. Real drivers (`mysql`, `mariadb`, `pgsql`, `sqlsrv`), running migrations against a live server, and seeding are **Stage 3 provisioning** — a separate milestone with its own checklist. The driver choice propagates: `.github/workflows/tests.yml` needs a matching `services:` block, credentials, and a health check. Switching drivers is never a one-line `.env` edit.

## Environment

Known, reproducible friction on this toolchain. None of these are code defects — document, don't design around.

- **`APP_URL` doubled-port bug** (Laravel Herd installer 1.24.2, deterministic, no flag controls it). The installer writes `APP_URL=http://localhost:8000:8000` into `.env`. Every subsequent `artisan` call dies with `Invalid URI: Host is malformed.` — including the installer's *own* in-flight calls, which is why an unprotected init yields a half-empty `tests/Pest.php`.
  - *Prevent the cascade:* `export APP_URL=http://localhost:8000` before `laravel new`. Dotenv's immutable mode makes the in-installer artisan calls read the good value.
  - *Still repair after:* the writer bug is independent — `.env` gets the doubled port regardless. Copy the good line from `.env.example` (§example.txt).
- **PHPStan "… stub is not a file"** — PHPStan caches under the shared system tmpdir, so unrelated projects collide. Clear it: `rm -rf "$(php -r 'echo sys_get_temp_dir();')/phpstan"`. A demo/scratch app built from this same idiom is a likely poisoner.
- **PHPStan 128M memory limit** — informational only. Did not reproduce on a fresh small project. If it does appear, raise `memory_limit` locally (CI's `setup-php` already runs unlimited). Do **not** "fix" it by narrowing `phpstan.neon` paths.
- **`laravel new` and existing directories** — must run from the *parent* directory; add `--force` when the target directory already exists, even if empty.
- **`composer.json` trailing newline** — the installer rewrites the file without one. Trivial churn; restore it so later diffs stay clean.

## Canonical example

`example.txt` — init sequence, annotated skeleton tree, and the delta files verbatim.

## Anti-patterns

- `composer require livewire/livewire` onto a bare `laravel new` — hand-wired layout/auth/Tailwind, off the kit upgrade path.
- Omitting `--livewire-class-components`, then hand-converting the SFC tree.
- Volt / `--mfc` / SFC mixed into a class-component project.
- Running `laravel new` without `export APP_URL=…` → malformed `.env`, dead artisan, half-written `tests/Pest.php`.
- Requiring a MySQL/Postgres server to finish init — or gating "done" on a migration against one.
- Hand-converting the kit's PHPUnit-style tests to Pest function syntax.
- Deleting or disabling PHPStan to make init green; lowering `phpstan.neon` level; excluding `app/Livewire`.
- Turning on `declare_strict_types` and absorbing the fallout with `@phpstan-ignore` / a baseline / `level: 5` instead of correcting the `@return` union — or leaving the fallout unfixed.
- Hand-typing `declare(strict_types=1)` per file instead of the Pint rule.
- `Route::get('/x', Component::class)` for full pages.
- Deleting `.github/workflows/tests.yml` "until the project is real".
- Hook in `.git/hooks` only → nobody else runs it.
- `vendor/bin/pint --test` in CI instead of `composer lint:check` → two sources of truth.
- Editing kit files before commit 1 → upgrade diff unreadable forever.
- `.env` committed; `database/database.sqlite` force-added.
- Presenting the kit as theme-agnostic while silently pulling in Flux.
