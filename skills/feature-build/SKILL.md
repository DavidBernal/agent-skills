---
name: feature-build
description: Build phase for a feature planned as a .feature spec (from the feature-spec skill). Use when asked to implement, build or continue a spec in specs/*.feature. Implements the feature until every checklist item is done and every Gherkin scenario passes as an automated test, without changing the agreed behaviour.
---

# Feature build (build phase)

You implement exactly one spec: the `.feature` file the user points to (usually under `specs/`). The spec is the contract: the decision record, the checklist and the scenarios.

## 1. Load the contract

- Read the whole `.feature`: decision record, out-of-scope list, checklist, scenarios and their `@S` ids.
- Read `AGENTS.md` / `CLAUDE.md` and follow the project's rules (dependencies, structure, style).
- Detect how tests run (`package.json` scripts, existing test folders).
- Change the feature tag `@status-planned` to `@status-in-progress`.

If the spec is ambiguous or contradicts the codebase in a way that changes behaviour, stop and report it; do not guess. Small technical details not covered by the spec are your call.

## 2. Make scenarios executable

Every scenario must be backed by an automated test that fails before the implementation and passes after it. Choose, in this order:

1. If the project already runs Gherkin (e.g. Cucumber, `@amiceli/vitest-cucumber`, `playwright-bdd`, `pytest-bdd`, `behave`, Reqnroll/SpecFlow, Godog), write step definitions for the `.feature` directly.
2. If the project uses Vitest, add `@amiceli/vitest-cucumber` as a dev dependency (pick the version whose `vitest` peer dependency matches the project's Vitest) and bind the `.feature` with `describeFeature`. One test file per spec, next to the code it exercises, named `<area>.feature.test.ts`. This makes every scenario and step show green/red in the test explorer and fails if a scenario or step is missing or its text drifts from the spec.
   - Step titles must match the `.feature` text exactly (including backticks); `<var>` placeholders stay literal in outlines and values come from the `variables` argument.
   - Share state between steps through a per-scenario object reset in the `Background` (or the first `Given`).
   - In CommonJS projects avoid top-level `await`: use `loadFeatureFromText(readFileSync(resolve(__dirname, '<path>.feature'), 'utf8'))`.
3. Otherwise, use the project's existing test runner, whatever the language: one test per scenario, named `[S<n>] <Scenario title>` (outlines: one test per Examples row), each following its Given/When/Then. Keep them in one test file per spec, named after the spec slug. Only add a Gherkin runner if the project's rules allow new dependencies and the user agrees.
4. If the project has no test runner at all, stop and propose the standard one for its stack before writing code; setting it up becomes the first checklist item.

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
