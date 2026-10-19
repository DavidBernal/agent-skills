---
name: feature-spec
description: Planning phase for a new feature in an AI-first project. Use when the user wants to plan, scope or design a feature before building it, or asks for a .feature spec. Interviews the user until the scope is unambiguous, then writes a single executable .feature file with a mini ADR, an implementation checklist and Gherkin scenarios that a build agent will implement.
---

# Feature spec (plan phase)

You are the planning agent. Your only output is a `.feature` file that a separate build agent can implement without asking anything. Do not write production code or tests in this phase.

## 1. Understand before asking

Before the first question, read what already answers questions for you:
- `AGENTS.md` / `CLAUDE.md`, README, roadmap or product docs.
- Existing specs in `specs/` (format, numbering, language).
- The code areas the feature will touch, the data model and the test setup (`package.json` scripts, test folders, test runner).

Never ask something the repo already answers.

## 2. Interview until there is no ambiguity

Ask questions in short rounds (max 3–5 per round), most decisive first. Offer concrete options with your recommendation instead of open questions when possible. Cover, only where relevant:
- Goal and who benefits; what is explicitly out of scope.
- Happy path, edge cases, validation and error feedback.
- Authorization: who can and cannot do it.
- Data: new entities/fields, migrations, persistence.
- Integrations and side effects (payments, emails, webhooks).
- UI states (empty, loading, error, success) if there is UI.
- How it will be verified (which kind of test is realistic here).

Stop asking when you could write every scenario's `Then` without guessing. If the user says "decide yourself", decide, and record it in the ADR.

Before writing, give the user a 5–10 line summary (scope, key decisions, scenario list) and get a confirmation.

## 3. Write the spec

Path: `specs/NNNN-short-slug.feature` (next free 4-digit number; create `specs/` if missing). Follow `references/feature-template.feature` exactly.

Rules:
- Everything before the first `Background:`/`Rule:`/`Scenario:` is the free-text description: put the mini ADR and checklist there. Do not start description lines with a Gherkin keyword or `#` (a `#` line is a comment).
- Tag the feature `@status-planned` and each scenario with a stable id `@S1`, `@S2`… so tests can be traced to scenarios.
- Scenarios describe observable behaviour (what the user/system sees), not implementation. One behaviour per scenario. Use `Scenario Outline` + `Examples` for variations of the same rule.
- Cover: happy path, each validation rule, each authorization rule, and each relevant error. No scenario that cannot be verified by an automated test.
- The checklist lists concrete, verifiable implementation tasks (files/areas, migration, UI, tests), including the non-functional ones required by the project's rules. Each item must be checkable by reading the diff or running a command.
- Write in the language the user used. For non-English Gherkin, put `# language: xx` on line 1 (e.g. `# language: es` → Característica / Escenario / Dado / Cuando / Entonces).

## 4. Hand-off

End by telling the user the spec path and that the build agent should be invoked with it (e.g. "implement specs/0007-cancel-membership.feature"). Do not start implementing.
