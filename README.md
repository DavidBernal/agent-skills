# agent-skills

Skills for AI coding agents (Claude Code, opencode, Cursor, Copilot…), installable with [skills.sh](https://skills.sh).

| Skill | Phase | What it does |
|---|---|---|
| `feature-spec` | Plan | Interviews you until the feature is clear and writes `specs/<ticket-or-number>-slug.feature` (or follows the repo's existing spec convention) with a mini ADR, a checklist and Gherkin scenarios. |
| `feature-build` | Build | Implements a spec: one test per scenario, every checklist item done, behaviour unchanged. |

## Install

```bash
npx skills add <github-user>/agent-skills -g           # all skills, global
npx skills add <github-user>/agent-skills --skill feature-spec
npx skills update                                      # pull new versions
```

## Flow

1. Plan agent: "plan a feature for …" → `feature-spec` → `specs/0001-….feature` (`@status-planned`).
2. Build agent: "implement specs/0001-….feature" → `feature-build` → `@status-done`.

## Plan-mode permissions

- **opencode**: let the `plan` agent write only in `specs/` (`~/.config/opencode/opencode.json`):
  ```json
  { "agent": { "plan": { "permission": { "edit": { "*": "deny", "specs/**": "allow" } } } } }
  ```
- **Claude Code**: plan mode can't write to the repo. Either run `feature-spec` in normal mode (the skill itself forbids code changes), or stay in plan mode: the spec goes into the plan and is written as the first step after you approve it.
