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

A retrieval-augmented **coding-style harness**, packaged as a Claude Code plugin. Instead of letting Claude write new code in its own default style, you load this plugin and it implements features in **your** framework-specific house conventions — drawn from a curated catalog of *codestyle idioms*.

The repo is both a **Claude Code marketplace** and a **single plugin** at its root, so it installs the same way as any published skills plugin.

## How it works

Each convention is a **codestyle idiom** stored under `codestyles/<framework>/<name>/`:

| File | Purpose |
|------|---------|
| `STYLE.md` | Intent, numbered rules, and boundaries (`use-when` / `use-when-not`). |
| `example.<ext>` | A canonical reference implementation to imitate. |
| `checklist.md` | Objectively verifiable conformance points. |

`codestyles/<framework>/INDEX.md` is the catalog that the harness reads to decide which idioms to load for a task.

Two skills drive it:

- **`apply-codestyle`** (consumption) — run in *your other projects*. Decomposes the task → retrieves the matching idioms from the catalog → implements to spec → verifies each artifact against its checklist. Reads the catalog from `${CLAUDE_PLUGIN_ROOT}/codestyles/`.
- **`add-codestyle`** (development) — run *inside this repo*. Guides a short discussion, then authors a new idiom (`STYLE.md` + example + checklist) and updates the `INDEX`. Writes to `./codestyles/`.

The split is deliberate: you *consume* the catalog from installed plugins in your projects, and you *grow* the catalog here, then push so consumers update.

## Install (consumers)

```
/plugin marketplace add <your-github-user>/codestyle-harness
/plugin install codestyle-harness@codestyle-harness
```

Then, in a project, ask Claude to build a feature — the `apply-codestyle` skill activates and follows the catalog. To pick up newly added idioms later: `/plugin update`.

## Add a new idiom (maintainer)

Work inside this repo and invoke the `add-codestyle` skill, or copy an existing idiom folder as a template. Keep each idiom single-purpose, make every rule checkable, and ensure the example satisfies its own checklist. Commit + push when done.

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

- Idioms are namespaced by **framework** so best practices never bleed across stacks and retrieval stays cheap.
- `version` is intentionally omitted from `plugin.json` so each commit auto-versions by git SHA — no manual version bumps as the catalog grows. Add a semver `version` later if you want explicit releases.
- Skills are model-invocable by default. To make one explicit-only (`/codestyle-harness:apply-codestyle`), add `disable-model-invocation: true` to its frontmatter.
