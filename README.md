# agent-skills

Skills for AI coding agents (Claude Code, opencode, Cursor, Copilot…), installable with [skills.sh](https://skills.sh).

| Skill | Phase | What it does |
|---|---|---|
| `feature-spec` | Plan | Interviews you until the change is clear, writes `specs/changes/<ticket-or-number>.md` (mini ADR, checklist, scenario delta) and updates the living Gherkin capabilities in `specs/capabilities/`. Follows the repo's existing spec convention if there is one. |
| `feature-build` | Build | Implements a change: one test suite per capability, every scenario passing, every checklist item done, behaviour unchanged. |

## Install

```bash
npx skills add <github-user>/agent-skills -g           # all skills, global
npx skills add <github-user>/agent-skills --skill feature-spec
npx skills update                                      # pull new versions
```

## Spec model

```
specs/
  capabilities/<domain>/<capability>.feature   # how it behaves today (living)
  changes/<ID>.md                              # why and what each change touched (frozen)
```

- Capabilities hold the user story, a **Current rules** list and the scenarios, each tagged with a stable ID and the changes behind it: `@grid-chart.02 @UNX-2813 @UNX-2817`.
- Changes hold the decision record, the checklist and a scenario delta (added / modified / removed IDs). They are never edited after they are done.
- One spec per ticket makes behaviour hard to find and forces new tickets to rewrite old specs. Here a ticket updates the capability and leaves its reasoning in its own change.

## Flow

1. Plan agent: "plan a feature for …" → `feature-spec` → `specs/changes/0001-….md` (`planned`) + capability edits.
2. Build agent: "implement specs/changes/0001-….md" → `feature-build` → `done`.

## Plan-mode permissions

- **opencode**: let the `plan` agent write only in `specs/` (`~/.config/opencode/opencode.json`):
  ```json
  { "agent": { "plan": { "permission": { "edit": { "*": "deny", "specs/**": "allow" } } } } }
  ```
- **Claude Code**: plan mode can't write to the repo. Either run `feature-spec` in normal mode (the skill itself forbids code changes), or stay in plan mode: the spec changes go into the plan and are written as the first step after you approve it.
