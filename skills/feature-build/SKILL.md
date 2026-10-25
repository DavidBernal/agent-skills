---
name: feature-build
description: Build phase for a change planned with the feature-spec skill. Use when asked to implement, build or continue a spec change in specs/changes/*.md (or a legacy specs/*.feature). Implements the change until every checklist item is done and every scenario in the touched capabilities passes as an automated test, without changing the agreed behaviour.
---

# Feature build (build phase)

You implement exactly one change: the `specs/changes/<ID>.md` file the user points to. The contract is that change (decision record, out-of-scope list, checklist, scenario delta) plus the capability files it lists (`specs/capabilities/**/*.feature`), whose scenarios describe the behaviour after the change.

If the repo uses another spec location or still has one `.feature` per ticket, follow its convention: for a legacy per-ticket `.feature`, the decision record, checklist, status tag and scenarios all live in that file.

## 1. Load the contract

- Read the whole change file and every capability it lists: **Current rules**, scenarios and their `@<capability>.NN` IDs. Use the scenario delta to find which scenarios are added, modified or removed.
- Read `AGENTS.md` / `CLAUDE.md` and the specs README, and follow the project's rules (dependencies, structure, style).
- Detect how tests run (`package.json` scripts, existing test folders) and locate each capability's test suite.
- Set the change's status to `in-progress`.

If the spec is ambiguous, or contradicts the codebase or another capability in a way that changes behaviour, stop and report it; do not guess. Small technical details not covered by the spec are your call.

Check the placement against what you find in the code. Stop and report, proposing where it should go, when:
- the code you change also implements rules of a capability the change does not list (its scenarios would now be wrong or untested);
- the behaviour lives in a different slice than the index says, or the capability's test suite would have to reach into another domain's code;
- an unlisted capability's scenarios start failing because of your change.

Do not silently move scenarios between capabilities or create a new capability during the build: placement is a planning decision.

## 2. Make scenarios executable

Every scenario in a touched capability must be backed by an automated test. Added and modified scenarios must fail before the implementation and pass after it. Each capability has **exactly one test suite**, named after the capability (`<capability>.feature.test.ts` or the runner's equivalent) and placed next to the code that owns it. Extend the existing suite; never create a ticket-named test file.

Choose the runner in this order:

1. If the project already runs Gherkin (e.g. Cucumber, `@amiceli/vitest-cucumber`, `playwright-bdd`, `pytest-bdd`, `behave`, Reqnroll/SpecFlow, Godog), write step definitions bound to the capability `.feature` directly.
2. If the project uses Vitest, add `@amiceli/vitest-cucumber` as a dev dependency (pick the version whose `vitest` peer dependency matches the project's Vitest) and bind the whole capability with one `describeFeature`. Every scenario and step shows green/red in the test explorer, and the suite fails if a scenario or step is missing or its text drifts from the spec.
   - Step titles must match the `.feature` text exactly (including backticks); `<var>` placeholders stay literal in outlines and values come from the `variables` argument.
   - Share state between steps through one per-scenario object reset in the `Background` (or the first `Given`). When a capability grows, extend that object and its helpers instead of creating a parallel harness.
   - Do not split a capability across suites with `includeTags`: `vitest-cucumber` skips an untagged `Background` under a tag filter, and the suites drift apart.
   - In CommonJS projects avoid top-level `await`: use `loadFeatureFromText(readFileSync(resolve(__dirname, '<path>.feature'), 'utf8'))`.
3. Otherwise, use the project's existing test runner, whatever the language: one test per scenario, named `[<capability>.NN] <Scenario title>` (outlines: one test per Examples row), each following its Given/When/Then, in one test file per capability. Only add a Gherkin runner if the project's rules allow new dependencies and the user agrees.
4. If the project has no test runner at all, stop and propose the standard one for its stack before writing code; setting it up becomes the first checklist item.

For removed scenarios, delete their step implementations and any helper left unused. For modified scenarios, update the existing steps; do not keep the old version alongside.

Write or update the tests first and run them to see them fail for the right reason.

## 3. Implement

- Implement the smallest change that satisfies the scenarios and checklist, respecting the decision record and out-of-scope list.
- Tick checklist items (`- [ ]` → `- [x]`) in the change file as you finish them, only when actually done.
- Never edit scenarios, `Examples`, **Current rules** or the decision record to make tests pass. If the spec turns out to be wrong, stop and report what you'd change and why, so the user can re-plan.
- Never edit other, older change files.

## 4. Definition of done

Done only when all are true:
- Every scenario in each touched capability has a passing test, including the ones this change did not modify (state the mapping for the added and modified ones).
- Every checklist item is ticked.
- The capability index in `specs/README.md` matches reality for the touched capabilities (entry points, code area, test suite). Fixing a stale index row is in scope; changing what a capability covers is not.
- Project checks pass (typecheck/lint/test scripts that exist).
- No placeholders, TODOs or mock data left in production code.

Then set the change's status to `done` and report: files changed, scenario ID → test mapping, commands run with their result, and anything deferred.
