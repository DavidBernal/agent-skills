---
name: scan
description: Adoption phase for an existing project that wants to start working with the spec and implement skills. Use when the user wants to bootstrap, backfill or reverse-engineer specs from an existing codebase, migrate legacy per-ticket .feature files, or asks for the specs that should have been written along the way. Scans the code, proposes a capability map, confirms it with the user, then writes the capability index, the living Gherkin capabilities describing today's behaviour and one baseline change that records how they were derived. Accepts a folder to limit the scan to one package or app of a monorepo.
argument-hint: "[folder]"
---

# Scan (adoption phase)

You bring an existing project into the spec model used by the `spec` and `implement` skills, as if it had followed it from the start. Your output is a `specs/` tree that describes how the system behaves **today**, so the next `/spec` can locate and modify behaviour instead of rediscovering it. Do not change production code or tests in this phase.

Use the formats from the `spec` skill (installed alongside this one): `../spec/references/capability-template.feature` and `../spec/references/specs-readme-template.md`, plus the rules in its sections 5 and 6 (Current rules, scenario IDs, unique titles, English only, no `# language:` header). For the baseline change use `references/baseline-change-template.md`.

## Principles

- **Describe, don't design.** Capabilities state what the code does now, not what it should do. Every rule and scenario comes from evidence: code, existing tests, schema constraints, docs. Never invent behaviour to make a capability look complete.
- **No history fiction.** You cannot recover the reasoning of past decisions, so do not fabricate one change per past ticket. All backfilled rules and scenarios point to one baseline change (`0000`). Real history is only used when it exists as specs (see legacy specs below).
- **Bugs are findings, not edits.** When behaviour looks wrong (inconsistent rules, missing validation, dead branches), ask the user. If it is a bug, still specify current behaviour only if the user wants it locked; otherwise leave it out of the scenarios and record it as a finding. Never fix it here.
- **Coverage is honest.** Whatever you did not specify goes to "Not covered by any capability yet" in the index. A small, correct map beats a large, guessed one.

## 0. Scope

The scan covers one **scope**: the folder passed as argument (e.g. `/scan apps/api`), or the repo root when none is given.

- **With a folder**: read and specify only code inside it. Code outside it (shared packages, other services) is context: read what the scope calls to understand its behaviour, but never write capabilities for it; a rule that lives in a shared package is listed in the index as provided by that package, not specified here. Specs go to `<folder>/specs/`, unless the repo already keeps specs elsewhere (e.g. one root `specs/` with a domain per package), in which case follow it.
- **Without a folder in a monorepo** (workspaces in `package.json`/`pnpm-workspace.yaml`, `nx.json`, `turbo.json`, `go.work`, Cargo/Maven/Gradle multi-module, or several apps with their own manifests): do not scan everything. List the packages/apps with one line each and ask which one to scan, recommending the one with most business logic. Scan one per run; each gets its own `specs/` and its own baseline `0000`.
- Every path in the specs (code area, test suite, entry points) is relative to the repo root, so `spec` and `implement` can use them from anywhere.

Below, `specs/` means the specs folder chosen here.

## 1. Survey

Read before asking anything, within the scope:
- `AGENTS.md` / `CLAUDE.md`, README, product docs, ADRs, API docs (OpenAPI, GraphQL schema).
- Stack, folder structure, data model (migrations, ORM models), test setup and existing test files.
- Entry points: routes/controllers, RPC/actions, jobs and schedulers, event and webhook handlers, CLI commands, screens.
- Existing specs in any form: `specs/`, `*.feature`, per-ticket specs, acceptance criteria in docs.
- Git history only for orientation (which areas change together, ticket keys), not as a source of rules.

For a large codebase, survey domain by domain; if you can run subagents, one per top-level domain in parallel, each returning entry points, rules with file references and existing tests.

## 2. Propose the capability map

Group the entry points into business capabilities, following the `spec` skill's model: a capability is a business capability, not an endpoint or a ticket; domains mirror the code's feature/domain folders; a rule shared by several entry points lives in one capability.

Present the map to the user before writing any scenario, as a table: domain, capability, what it covers (one line), entry points, code area, existing test suite. Also list:
- Areas you propose to leave **not covered** yet (infrastructure, admin tooling, dead code, areas too large for this pass) and why.
- Code that mixes several capabilities or a capability spread across unrelated folders, with your proposal.
- Suspected bugs or contradictions found so far.

Ask in short rounds (max 3–5 questions), with options and your recommendation. Agree on scope: all capabilities now, or a priority subset (the areas the team will change next) with the rest listed as not covered. Get the map confirmed before step 3.

## 3. Write the capabilities

For each confirmed capability, read its code paths and tests in full and create `specs/capabilities/<domain>/<capability>.feature`:

- **User story** from docs or the evident purpose; ask if the beneficiary is unclear.
- **Current rules**: the durable business rules (validation, authorization, state transitions, limits, side effects), each ending with `[0000]`.
- **Scenarios**, numbered `@<capability>.01` upwards, each tagged `@0000`: happy path, each validation rule, each authorization rule, each relevant error and side effect. Observable behaviour only, written so an automated test can verify it. Prefer behaviour already covered by tests; for untested behaviour, read the code path carefully and keep the scenario narrow.
- When a rule cannot be determined from the code (configuration-dependent, external system, unclear intent), ask, or leave it out and record it as an open question. Do not write a scenario you are unsure of.

Work one domain at a time and show the user each domain's capabilities briefly before moving on when the map is large.

## 4. Legacy specs

If the repo already has specs that do not follow the model (one `.feature` per ticket, acceptance criteria in docs), migrate them instead of discarding their history, once the user agrees:
- Each legacy ticket spec becomes a change `specs/changes/<ticket>.md` with status `done`, its decision record and checklist preserved as written (mark unknown fields as `unknown`, never invent them).
- Its scenarios move into the capability they belong to, tagged with the capability ID plus the ticket ID instead of `0000`; the rules they back cite the ticket.
- Scenarios that the code no longer satisfies are not migrated as true behaviour: list them in the baseline change as removed or contradicted, with evidence.
- Delete the legacy files only after the migration is confirmed, and keep their paths in the baseline change.

If the user prefers to keep the legacy convention, stop: the `spec` skill already follows it.

## 5. Write the index and the baseline change

- `specs/README.md` from the `spec` skill's template: one row per capability (covers, entry points, code area, test suite or `none yet`) and the honest "Not covered by any capability yet" list.
- `specs/changes/0000-baseline.md` from `references/baseline-change-template.md`: status `planned`, the commit it was derived from, every capability created, sources used, findings (suspected bugs, contradictions, open questions, dead code) and a checklist to make every scenario executable.

The baseline checklist is for `implement`: one item per capability to back its scenarios with tests in that capability's single suite (extending an existing test file when there is one), plus project checks. Those are characterization tests: they must pass **without changing production code**.

If you cannot write files in this phase, put every file with its target path in your plan, and make writing them exactly as planned the first step once approved.

## 6. Hand-off

Report: capabilities created per domain, what was left not covered, the findings that need a decision, and the next steps:
1. `/implement specs/changes/0000-baseline.md` to turn the scenarios into passing tests (optional but recommended: until then the capabilities are documentation, not a contract).
2. `/spec …` for any new work, which will now locate changes through the index.
3. Turn each confirmed bug in the findings into its own `/spec` change.
