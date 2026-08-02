# Checklist — laravel/livewire-project-init

Init scope only. All must be yes — **with no database server running**.

## Bootstrap

- [ ] `APP_URL` was exported before `laravel new` (`export APP_URL=http://localhost:8000`).
- [ ] Scaffolded via `laravel new … --livewire --livewire-class-components --pest --git --npm --database=sqlite` — not a bare skeleton + manual `composer require livewire/livewire`, not Breeze, not `--using=`.
- [ ] `--database=sqlite`; `database/database.sqlite` exists and is untracked.
- [ ] Commit 1 is untouched kit output; every deviation is a later commit.
- [ ] `.env`'s `APP_URL` matches `.env.example` — no doubled port; `php artisan about` runs without "Invalid URI: Host is malformed."
- [ ] `composer.json` ends with a trailing newline (installer strips it).

## Structure

- [ ] Components are class-based under `app/Livewire/` — no `⚡*.blade.php` single-file components, no `--mfc`, no Volt.
- [ ] Every component class has a 1:1 view at `resources/views/livewire/<domain>/<kebab-name>.blade.php`; `render()` present only where the mirror doesn't hold.
- [ ] `app/Livewire/` subfolders named by domain capability, not technical bucket (`Forms/`, `Tables/`, `Components/`).
- [ ] Full-page routes use `Route::livewire(…, Component::class)->name(…)`; no `Route::get(…, Component::class)`.
- [ ] Per-domain route files `require`d from `routes/web.php`; `web.php` holds no domain route bodies.

## Gates

- [ ] `pint.json`, `phpstan.neon`, `.github/workflows/tests.yml`, `.github/dependabot.yml` all present and kit-derived.
- [ ] PHPStan/Larastan is still wired and running — not deleted, not disabled, not skipped in CI.
- [ ] `phpstan.neon` level ≥ 7, paths still cover `app/ bootstrap/app.php config/ database/ routes/`; no `app/Livewire` exclusion.
- [ ] `grep -r "@phpstan-ignore\|phpstan-baseline"` finds nothing.
- [ ] `.githooks/pre-commit` committed and executable, runs `composer lint` + `composer types:check`.
- [ ] `hooks:install` composer script exists (`git config core.hooksPath .githooks`) and is chained from `setup`.
- [ ] Gates referenced only as composer scripts — `grep -r "vendor/bin/\(pint\|phpstan\|pest\)"` finds nothing in CI, hooks, or docs.

## Tests

- [ ] Kit tests are unmodified — no hand-conversion of `class *Test extends TestCase` to Pest function syntax.
- [ ] `tests/Pest.php` is kit-generated and non-empty (binds `Tests\TestCase`, `RefreshDatabase` for `Feature`).
- [ ] `composer test` passes under Pest on SQLite — expect **33 passed**.

## Frontend

- [ ] Flux UI was disclosed as part of `--livewire` before scaffolding — the team knows the project depends on `livewire/flux` (free + paid Pro tiers) and that ~26 kit views consume `<flux:*>`.
- [ ] Frontend deps are kit default only (Flux UI + Tailwind 4 + Vite) — no second CSS framework, bundler, or component library.

## Repo hygiene

- [ ] `.env.example` committed and lists every key the app reads; `.env` untracked.
- [ ] `database/.gitignore` (`*.sqlite*`) intact; no SQLite file tracked.

## Done

- [ ] On a clean clone, with no DB server running: `composer install` → `composer lint:check` → `composer types:check` → `composer test` all green.

## Strict types — only if adopted (optional, deferrable)

Skip this block entirely if the `declare_strict_types` delta was deferred. If adopted, all must be yes:

- [ ] `pint.json` sets `"rules": {"declare_strict_types": true}`.
- [ ] `composer lint:check` passes → every PHP file carries `declare(strict_types=1)`; none hand-typed as a one-off exemption.
- [ ] Strict-types fallout in `app/Concerns/ProfileValidationRules.php` fixed by naming `Unique` in the `@return` unions (all three annotations) — not by `@phpstan-ignore`, a PHPStan baseline, or a level drop.
- [ ] Rule and fallout fix landed in the same commit — no red intermediate state.

## Out of scope (Stage 3 — do NOT check here)

Real DB driver (`mysql`/`mariadb`/`pgsql`/`sqlsrv`), migrations against a live server, seeding, and the matching `services:` block in `.github/workflows/tests.yml`. Provisioning has its own milestone; init must not depend on it.
