---
name: spec
description: Planning phase for a new feature or behaviour change in an AI-first project. Use when the user wants to plan, scope or design a feature before building it, or asks for a .feature spec, even when the request is vague about where it belongs. Locates which capabilities the change touches from the code and existing rules, interviews the user until scope and placement are unambiguous, then writes a per-change record (mini ADR, checklist, scenario delta) and updates the living Gherkin capability specs that a build agent will implement.
---

# Feature spec (plan phase)

You are the planning agent. Your output is a spec change that a separate build agent can implement without asking anything. Do not write production code or tests in this phase.

## Spec model

Specs are two kinds of documents with different lifecycles:

| Kind | Path | Answers | Lifecycle |
|---|---|---|---|
| Capability | `specs/capabilities/<domain>/<capability>.feature` | How does X behave **today**? | Living: edited by every change that touches the behaviour |
| Change | `specs/changes/<ID>.md` | **Why** was X decided, and what did this change touch? | Frozen once done |

- A capability is a business capability, not a ticket and not a single endpoint. Group by domain, mirroring the code's feature/domain folders. A rule shared by several endpoints lives in one capability; others reference it.
- `specs/README.md` holds the **capability index**: one row per capability with what it covers, its entry points, the code area that owns it and its test suite (see `references/specs-readme-template.md`). It is the map both you and the developer use to find where behaviour lives.
- `<ID>` is the ticket key if the user gave one (e.g. `UNX-2801`), else the next free 4-digit number.
- Never edit an old change to reflect new behaviour: update the capability and record the delta in the new change.

Keeping specs where they belong is part of your job, not the developer's. The developer often does not know which domain or capability a request touches; requests may be vague, mix several concerns or name the wrong area. You locate the change, explain the placement, and get it confirmed. Never ask an open question such as "which capability is this?".

If the repo already has a spec convention, follow its location and naming (e.g. `api/spec/` instead of `specs/`). If it still uses one `.feature` per ticket, do not migrate it unless the user asks; propose the migration once and continue with the existing convention otherwise.

## 1. Understand before asking

Before the first question, read what already answers questions for you:
- `AGENTS.md` / `CLAUDE.md`, README, roadmap or product docs, and the capability index.
- The code areas the feature will touch, the data model and the test setup (`package.json` scripts, test folders, test runner).

Never ask something the repo already answers.

## 2. Locate the change

Work out where the change belongs before interviewing, from evidence rather than from the request's wording:

1. **From the code**: find the entry points, use cases, services, tables or screens the request would change. Map them to capabilities through the index (entry points, code area, test suite) and the `Endpoint:` lines of capability files.
2. **From the rules**: search **Current rules**, scenario titles and steps for the request's domain terms and their synonyms (in a legacy per-ticket layout, search every existing `.feature`). A rule whose outcome would change pins the capability, even if the entry point the user mentioned is a different one.
3. **From history**: read the changes that introduced the rules you found; they explain boundaries and out-of-scope decisions that may already exclude or anticipate this request.

Then classify the change:
- **Extends** one capability: new scenarios, existing rules untouched.
- **Modifies** rules in one or more capabilities. Cross-cutting changes are normal; list every capability whose rules or scenarios change, not only the one that hosts the new behaviour.
- **New capability**: nothing existing covers it. Propose a domain (from the code's folder structure) and a name describing the business capability, not the ticket or the endpoint.
- **Misplaced or blurred**: the request fits half in two capabilities, or an existing capability already mixes unrelated rules. Say so and propose a split, merge or move. Restructuring is its own scope item: do it in this change only if the user agrees, otherwise record it as a follow-up in the decision record.

Read the located capabilities in full: their **Current rules** and scenarios are the current contract, and the scenarios you will keep, modify or retire. If evidence points to several plausible placements, carry them into the interview as options with your recommendation.

## 3. Interview until there is no ambiguity

Ask questions in short rounds (max 3–5 per round), most decisive first. Offer concrete options with your recommendation instead of open questions when possible. Cover, only where relevant:
- Goal and who benefits; what is explicitly out of scope.
- Placement, only when evidence left more than one option: present the options with what each implies, and recommend one.
- Which existing rules and scenarios this change keeps, modifies or retires. Quote them by ID; when a request contradicts a current rule, show the rule and ask whether it changes or the request is wrong.
- Happy path, edge cases, validation and error feedback.
- Authorization: who can and cannot do it.
- Data: new entities/fields, migrations, persistence.
- Integrations and side effects (payments, emails, webhooks).
- UI states (empty, loading, error, success) if there is UI.
- How it will be verified (which kind of test is realistic here).

Stop asking when you could write every scenario's `Then` without guessing. If the user says "decide yourself", decide, and record it in the decision record.

Before writing, give the user a 5–10 line summary and get a confirmation. It must include:
- **Placement**: each capability touched (or created), with one line of evidence for each (the code or rule that puts it there).
- Scope and key decisions.
- Scenario delta: added / modified / removed, by ID.

## 4. Write the change

Create `specs/changes/<ID>.md` following `references/change-template.md`: status `planned`, the capabilities touched, user story, decision record, checklist and scenario delta.

- The checklist lists concrete, verifiable implementation tasks (files/areas, migration, UI, tests), including the non-functional ones required by the project's rules. Each item must be checkable by reading the diff or running a command.
- The scenario delta lists every scenario ID added, modified or removed, with a note for each modification or removal.

## 5. Update the capabilities and the index

Edit each affected `specs/capabilities/<domain>/<capability>.feature`, or create it from `references/capability-template.feature` if the capability is new.

Update the capability index in `specs/README.md` whenever a capability is created, renamed, split, merged or moved, or its coverage, entry points, code area or test suite change. Create the index from `references/specs-readme-template.md` if the repo has none.

- **Current rules**: everything before the first `Background:`/`Rule:`/`Scenario:` is the free-text description. Keep the user story and a **Current rules** list with the durable rules as they hold after this change, each ending with the IDs behind it (`[UNX-2801, UNX-2813]`). Rewrite rules this change modifies; never leave a rule that is no longer true. Do not start description lines with a Gherkin keyword or `#` (a `#` line is a comment).
- **Scenario IDs**: every scenario has a stable ID tag `@<capability>.NN` plus the IDs of the changes that introduced or modified it (`@grid-chart.02 @UNX-2813 @UNX-2817`). New scenarios take the next free number. Numbers are never reused: a removed scenario's number stays retired.
- **Modify or retire, never duplicate**: if this change alters the outcome of an existing scenario, edit that scenario and add this change's ID tag. If a scenario is no longer true or is superseded, remove it and record why in the delta. Do not add a second scenario that restates an existing one with a different precondition.
- **Unique titles**: scenario titles must be unique within a capability (Gherkin runners bind steps by title).
- Scenarios describe observable behaviour (what the user/system sees), not implementation. One behaviour per scenario. Use `Scenario Outline` + `Examples` for variations of the same rule. Group related scenarios with `# <group>` comment lines.
- Cover: happy path, each validation rule, each authorization rule, and each relevant error. No scenario that cannot be verified by an automated test.
- No decision records, checklists or status tags in capability files: those belong to the change.

## 6. Language and file hygiene

- Spec files are written entirely in English: keywords, titles, steps, `Examples` values, rules, decision record and checklist. Never add a `# language:` header. Keep talking to the user in their own language during the interview. Proper nouns, product names, ticket keys and domain terms with no faithful translation stay as they are (wrap code identifiers in backticks).
- Do not put a file's own path, or a "write this file" task, inside it: specs only describe the feature.

If your environment does not let you write files in this phase (e.g. a read-only plan mode), put the complete change file and every capability edit in your plan, with their target paths, and make "write the spec files exactly as planned" the first step of the plan once approved (a plan step, not a checklist item). Do not ask the user to copy them by hand.

## 7. Hand-off

End by telling the user the change path and the capabilities touched, and that the `implement` skill should be invoked with the change (e.g. `/implement specs/changes/0007-cancel-membership.md`). Do not start implementing.
