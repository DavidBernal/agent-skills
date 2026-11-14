---
name: verify
description: Independent, read-only check of a change built with the implement skill, meant to run in a fresh context (a subagent) once the build believes it is done. Use when implement hands off for verification, or when the user asks to verify, check or audit a change in specs/changes/*.md against its spec. Re-runs the checks, confirms every scenario is really tested, that no test or spec was weakened, and that the change respects its decision record, constraints and scope. Reports findings; never edits.
argument-hint: "<specs/changes/ID.md> [base-ref]"
---

# Verify (independent check)

You check a change that someone else built. You start without their reasoning on purpose: judge the result against the contract, not against the builder's explanation. Do not edit any file. Your output is a verdict and a list of findings.

## 1. Inputs

- The change file `specs/changes/<ID>.md` and every capability it lists. These are the contract.
- The base the build started from: the ref you were given, else `HEAD`. The diff under review is `git diff <base>` plus untracked files (`git status --porcelain`). Ignore paths you were told were already modified before the build.
- `AGENTS.md` / `CLAUDE.md`, the specs README, and any skill named in the change's **Constraints**.

Do not ask the builder for a summary and do not trust one if given. If there is no git, ask for the list of changed files.

## 2. Checks

Run every check, then report all findings together.

1. **Checks pass, run by you.** Run the project's typecheck, lint and test scripts that exist, and each touched capability's test suite. Report the commands and the result.
2. **Every scenario is really tested.** Each scenario in the touched capabilities maps to a test, one test per `Examples` row in outlines. For added and modified scenarios, read the test: it sets up the `Given`, performs the `When` and asserts the `Then`. Flag empty steps, assertions on mocks instead of outcomes, assertions that cannot fail, and a `Then` with several outcomes where only some are asserted.
3. **Nothing was weakened.** In tests that existed before the build: no deleted, skipped (`.skip`, `xit`, `@skip`, `--grep` filters) or focused (`.only`) tests, and no loosened assertions or changed expected values that the scenario delta does not justify. In spec files, the build may only tick checklist items and change the status. Scenarios, `Examples`, **Current rules**, decision record, constraints and concerns stay as planned, and older change files stay untouched.
4. **The contract is respected.**
   - Every ticked checklist item is visible in the diff or proven by a command. No item is ticked without being done.
   - Nothing in **Out of scope** was built, and the decision record was followed.
   - Each row in **Constraints** holds as stated. Re-read the source skill or rule for the code you are checking, not only the row.
   - Each concern's handling was followed.
   - For a baseline change (`Type: baseline`), production code is untouched: only tests and the change file moved.
5. **Placement holds.** Changed code does not implement rules of a capability the change does not list, and the specs README rows for touched capabilities match the code areas, entry points and test suites.
6. **Code quality.** Apply the `code` skill's review checklist if it is installed. Otherwise check at least that no business rule is in two places or inside an entry point or UI component, that no abstraction or option exists without a reason today, and that no placeholders, TODOs or mock data remain in production code.

## 3. Report

Start with the verdict: **pass** (no blocking findings) or **fail**. Then list the findings, blocking first, one line each: severity, `file:line`, check number, what is wrong with the evidence, and the fix you suggest.

- **Blocking**: a failing check, a scenario without a real test, a weakened test or spec, a checklist item ticked but not done, out-of-scope work, a broken constraint or concern handling, misplaced behaviour.
- **Minor**: code quality findings and stale index rows that do not change behaviour.

When a finding means the spec itself is wrong (a scenario cannot hold together with a constraint, say), mark it **spec** instead: the fix is a new `/spec`, not code. End with the commands you ran and anything you could not check.
