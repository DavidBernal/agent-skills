---
name: feature-build
description: Build phase for a feature planned as a .feature spec (from the feature-spec skill). Use when asked to implement, build or continue a spec in specs/*.feature. Implements the feature until every checklist item is done and every Gherkin scenario passes as an automated test, without changing the agreed behaviour.
---

# Feature build (build phase)

You implement exactly one spec: `specs/NNNN-*.feature`. The spec is the contract: the decision record, the checklist and the scenarios.

## 1. Load the contract

- Read the whole `.feature`: decision record, out-of-scope list, checklist, scenarios and their `@S` ids.
- Read `AGENTS.md` / `CLAUDE.md` and follow the project's rules (dependencies, structure, style).
- Detect how tests run (`package.json` scripts, existing test folders).
- Change the feature tag `@status-planned` to `@status-in-progress`.

If the spec is ambiguous or contradicts the codebase in a way that changes behaviour, stop and report it; do not guess. Small technical details not covered by the spec are your call.

## 2. Make scenarios executable

Every scenario must be backed by an automated test that fails before the implementation and passes after it. Choose, in this order:

1. If the project already runs Gherkin (e.g. `@cucumber/cucumber`, `playwright-bdd`, `@amiceli/vitest-cucumber`), write step definitions for the `.feature` directly.
2. Otherwise, do not add a Gherkin runner unless the project rules allow new dependencies. Write tests in the existing runner with one test per scenario, named `[S<n>] <Scenario title>` (outlines: one test per Examples row), each following its Given/When/Then. Keep them in one test file per spec, named after the spec slug.

Write the tests first and run them to see them fail for the right reason.

## 3. Implement

- Implement the smallest change that satisfies the scenarios and checklist, respecting the decision record and out-of-scope list.
- Tick checklist items (`- [ ]` → `- [x]`) in the `.feature` as you finish them, only when actually done.
- Never edit scenarios, `Examples` or the decision record to make tests pass. If the spec turns out to be wrong, stop and report what you'd change and why, so the user can re-plan.

## 4. Definition of done

Done only when all are true:
- Every `@S` scenario has a passing test (state the mapping).
- Every checklist item is ticked.
- Project checks pass (typecheck/lint/test scripts that exist).
- No placeholders, TODOs or mock data left in production code.

Then set the tag to `@status-done` and report: files changed, scenario → test mapping, commands run with their result, and anything deferred.
