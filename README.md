# agent-skills

Skills for AI coding agents (Claude Code, opencode, Cursor, Copilot…), installable with [skills.sh](https://skills.sh).

| Skill | Phase | What it does |
|---|---|---|
| `feature-spec` | Plan | Interviews you until the feature is clear and writes `specs/NNNN-slug.feature` with a mini ADR, a checklist and Gherkin scenarios. |
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

Note: plan modes are usually read-only. Allow the plan agent to write in `specs/` (or let it hand the file to the build agent) so it can save the spec.
