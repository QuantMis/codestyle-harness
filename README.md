```
██████╗ ██████╗ ██████╗ ███████╗███████╗████████╗██╗   ██╗██╗     ███████╗
██╔════╝██╔═══██╗██╔══██╗██╔════╝██╔════╝╚══██╔══╝╚██╗ ██╔╝██║     ██╔════╝
██║     ██║   ██║██║  ██║█████╗  ███████╗   ██║    ╚████╔╝ ██║     █████╗
██║     ██║   ██║██║  ██║██╔══╝  ╚════██║   ██║     ╚██╔╝  ██║     ██╔══╝
╚██████╗╚██████╔╝██████╔╝███████╗███████║   ██║      ██║   ███████╗███████╗
 ╚═════╝ ╚═════╝ ╚═════╝ ╚══════╝╚══════╝   ╚═╝      ╚═╝   ╚══════╝╚══════╝
██╗  ██╗ █████╗ ██████╗ ███╗   ██╗███████╗███████╗███████╗
██║  ██║██╔══██╗██╔══██╗████╗  ██║██╔════╝██╔════╝██╔════╝
███████║███████║██████╔╝██╔██╗ ██║█████╗  ███████╗███████╗
██╔══██║██╔══██║██╔══██╗██║╚██╗██║██╔══╝  ╚════██║╚════██║
██║  ██║██║  ██║██║  ██║██║ ╚████║███████╗███████║███████║
╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚══════╝╚══════╝
```

# codestyle-harness

Claude Code plugin. Makes Claude write new code in **your** framework conventions, not its default style. Conventions live in a curated catalog of *codestyle idioms*.

Repo = marketplace **+** single plugin at root. Installs like any skills plugin.

## How it works

One idiom = folder `codestyles/<framework>/<name>/`, three files:

| File | Holds |
|------|-------|
| `STYLE.md` | intent, numbered rules, `use-when` / `use-when-not` |
| `example.<ext>` | canonical reference to imitate |
| `checklist.md` | yes/no conformance points |

`codestyles/<framework>/INDEX.md` = catalog the harness reads to pick idioms.

Two skills:

- **`apply-codestyle`** — consume, in *other projects*. Decompose task → retrieve matching idioms → implement → verify vs checklist. Reads `${CLAUDE_PLUGIN_ROOT}/codestyles/`.
- **`add-codestyle`** — develop, *in this repo*. Discuss → author idiom (`STYLE.md` + example + checklist) → update `INDEX`. Writes `./codestyles/`.

Split is deliberate: consume from installed plugin, grow here, push, consumers update.

## Install (consumers)

```
/plugin marketplace add QuantMis/codestyle-harness
/plugin install codestyle-harness@codestyle-harness
```

Then ask Claude to build a feature — `apply-codestyle` fires, follows the catalog. Get new idioms later: `/plugin update`.

## Add an idiom (maintainer)

In this repo: run `add-codestyle`, or copy an idiom folder. Keep single-purpose, every rule checkable, example passes its own checklist. Commit + push.

## Layout

```
codestyle-harness/
├── .claude-plugin/
│   ├── plugin.json          # plugin manifest (skills auto-discovered from ./skills)
│   └── marketplace.json     # marketplace catalog (this plugin, source "./")
├── skills/
│   ├── apply-codestyle/SKILL.md
│   └── add-codestyle/SKILL.md
└── codestyles/
    └── laravel/
        ├── INDEX.md         # the catalog for Laravel idioms
        └── crud-controller/
            ├── STYLE.md
            ├── example.php
            └── checklist.md
```

## Notes

- Namespaced by **framework** — no cross-stack bleed, cheap retrieval.
- No `version` in `plugin.json` → auto-versions by git SHA, no manual bumps. Add semver later for explicit releases.
- Skills model-invocable by default. Explicit-only: add `disable-model-invocation: true` to frontmatter.
