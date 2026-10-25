# Specs

- `capabilities/`: how the system behaves **today**, one living Gherkin file per business capability.
- `changes/`: **why** each change was made and what it touched, one frozen record per ticket.

## Capability index

| Capability | Covers | Entry points | Code area | Test suite |
|---|---|---|---|---|
| [`<domain>/<capability>`](capabilities/<domain>/<capability>.feature) | <one line: the business behaviour and its boundary> | <endpoints, jobs, events, screens> | <`src/features/<domain>/<slice>`> | <`src/features/<domain>/<slice>/<capability>.feature.test.ts`> |

Not covered by any capability yet: <legacy areas without specs, so nobody assumes they are specified>.
