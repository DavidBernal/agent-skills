# <ID> — <Short change name>

- Status: planned
- Capabilities: [<capability>](../capabilities/<domain>/<capability>.feature)

## User story

As a <role>
I want <capability>
So that <benefit>

## Decision record

- Context: <why this change, what constraint or problem exists today>
- Decision: <the approach chosen, in 1-3 lines>
- Alternatives considered: <option> (discarded because <reason>)
- Consequences: <trade-offs, follow-ups, what this makes harder>
- Risks: <what this could break and the riskiest step, with the checklist item or scenario that guards it>
- Out of scope: <explicitly excluded items>

## Constraints

| Constraint | Source | Met by |
|---|---|---|
| <rule that limits this change> | <`CLAUDE.md` / `<skill-name>` skill / `<capability>` rule> | <decision or scenario ID that satisfies it> |

## Concerns

1. <What could not be fully resolved, e.g. two constraints that conflict.> Handling: <what the build does about it>. Decides: <who can change it>.

## Checklist

- [ ] <Data: migration / model change> (`<capability>.04`)
- [ ] <Server: action or endpoint with validation + authorization> (`<capability>.02`, `<capability>.04`)
- [ ] <UI: screens and states (empty, loading, error, success)> (`<capability>.04`)
- [ ] <Tests: steps for every added or modified scenario in the capability's test suite>
- [ ] <Verification: typecheck and test commands pass>

## Scenario delta

| Change | Scenario ID | Scenario | Notes |
|---|---|---|---|
| Added | `<capability>.04` | <title> | |
| Modified | `<capability>.02` | <title> | <what changed and why> |
| Removed | `<capability>.03` | <title> | <superseded by / no longer true because> |
