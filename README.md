# agent-skills

Skills for AI coding agents (Claude Code, opencode, Cursor, Copilot…), installable with [skills.sh](https://skills.sh).

| Skill | Phase | What it does |
|---|---|---|
| `spec` | Plan | Works out which capabilities a (possibly vague) request touches, interviews you until scope and placement are clear, writes `specs/changes/<ticket-or-number>.md` (mini ADR, checklist, scenario delta) and updates the living Gherkin capabilities in `specs/capabilities/`. Follows the repo's existing spec convention if there is one. |
| `implement` | Build | Implements a change: one test suite per capability, every scenario passing, every checklist item done, behaviour unchanged. |

## Install

```bash
npx skills add DavidBernal/agent-skills -g       # all skills, global
npx skills add DavidBernal/agent-skills --skill spec
npx skills update                                # pull new versions
```

## Spec model

```
specs/
  capabilities/<domain>/<capability>.feature   # how it behaves today (living)
  changes/<ID>.md                              # why and what each change touched (frozen)
```

- Capabilities hold the user story, a **Current rules** list and the scenarios, each tagged with a stable ID and the changes behind it: `@grid-chart.02 @UNX-2813 @UNX-2817`.
- Changes hold the decision record, the checklist and a scenario delta (added / modified / removed IDs). They are never edited after they are done.
- `specs/README.md` is the capability index (what each capability covers, entry points, code area, test suite). `spec` uses it, together with the code and existing rules, to place a change even when the request doesn't say where it belongs, and keeps it up to date.
- One spec per ticket makes behaviour hard to find and forces new tickets to rewrite old specs. Here a ticket updates the capability and leaves its reasoning in its own change.

## Flow

1. Plan: `/spec add …` creates `specs/changes/0001-….md` (`planned`) and updates the affected capabilities.
2. Build: `/implement specs/changes/0001-….md` implements the change and marks it `done`.

## Plan-mode permissions

- **opencode**: let the `plan` agent write only in `specs/` (`~/.config/opencode/opencode.json`):
  ```json
  { "agent": { "plan": { "permission": { "edit": { "*": "deny", "specs/**": "allow" } } } } }
  ```
- **Claude Code**: plan mode can't write to the repo. Either run `/spec` in normal mode (the skill itself forbids code changes), or stay in plan mode: the spec changes go into the plan and are written as the first step after you approve it.
