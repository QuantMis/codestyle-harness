# Checklist — laravel/livewire-project-init

All must be yes.

- [ ] Scaffolded via `laravel new … --livewire --livewire-class-components --pest --git --npm --database=<driver>` — not a bare skeleton + manual `composer require livewire/livewire`, not Breeze, not `--using=`.
- [ ] Commit 1 is untouched kit output; every deviation is a later commit.
- [ ] Components are class-based under `app/Livewire/` — no `⚡*.blade.php` single-file components, no `--mfc`, no Volt.
- [ ] Every component class has a 1:1 view at `resources/views/livewire/<domain>/<kebab-name>.blade.php`; `render()` present only where the mirror doesn't hold.
- [ ] `app/Livewire/` subfolders named by domain capability, not technical bucket (`Forms/`, `Tables/`, `Components/`).
- [ ] Full-page routes use `Route::livewire(…, Component::class)->name(…)`; no `Route::get(…, Component::class)`.
- [ ] Per-domain route files `require`d from `routes/web.php`; `web.php` holds no domain route bodies.
- [ ] `pint.json`, `phpstan.neon`, `.github/workflows/tests.yml`, `.github/dependabot.yml` all present and kit-derived.
- [ ] `phpstan.neon` level ≥ 7, paths still cover `app/ bootstrap/app.php config/ database/ routes/`; no `app/Livewire` exclusion.
- [ ] `pint.json` sets `"rules": {"declare_strict_types": true}`.
- [ ] `composer lint:check` passes → every PHP file carries `declare(strict_types=1)`; none hand-typed as a one-off exemption.
- [ ] Strict-types fallout in `app/Concerns/ProfileValidationRules.php` fixed by naming `Unique` in the `@return` unions — not by `@phpstan-ignore`, a PHPStan baseline, or a level drop.
- [ ] `grep -r "@phpstan-ignore\|phpstan-baseline"` finds nothing.
- [ ] `.githooks/pre-commit` committed and executable, runs `composer lint` + `composer types:check`.
- [ ] `hooks:install` composer script exists (`git config core.hooksPath .githooks`) and is chained from `setup`.
- [ ] Gates referenced only as composer scripts — `grep -r "vendor/bin/\(pint\|phpstan\|pest\)"` finds nothing in CI, hooks, or docs.
- [ ] Tests are Pest syntax with `tests/Pest.php` binding `Tests\TestCase`; no `class *Test extends TestCase`.
- [ ] `.env.example` committed and lists every key the app reads; `.env` untracked.
- [ ] `database/.gitignore` (`*.sqlite*`) intact; no SQLite file tracked.
- [ ] Frontend deps are kit default only (Flux UI + Tailwind 4 + Vite) — no second CSS framework, bundler, or component library.
- [ ] `composer ci:check` passes on a clean clone.
