# 0000 — Baseline specs from existing code

- Status: planned
- Type: baseline
- Scope: <folder scanned, or repo root>
- Derived from: <branch> @ <commit sha>, <date>
- Capabilities: [<domain>/<capability>](../capabilities/<domain>/<capability>.feature), …

## Decision record

- Context: the project existed before adopting capability specs; behaviour was only described by code, tests and docs.
- Decision: capabilities describe behaviour as observed at the commit above. Every backfilled rule and scenario cites this change. Real ticket history is kept only where it existed as specs (migrated legacy specs).
- Sources: <code areas, test files, docs, API schemas, legacy specs read>
- Out of scope: <areas listed as not covered in specs/README.md, and why>

## Findings

| Kind | Where | Finding | Decision |
|---|---|---|---|
| Suspected bug | <`path/to/file.ts:42`> | <what the code does vs what seems intended> | <locked as current behaviour / left unspecified, needs a /spec change> |
| Contradiction | <capability or files> | <two places applying different rules> | <…> |
| Open question | <capability> | <rule that could not be determined from the code> | <unspecified until answered> |
| Dead code | <path> | <unreachable entry point or branch> | <…> |

## Checklist

- [ ] <Tests: back every scenario of `<domain>/<capability>` with a test in its suite (`<path>`), passing without production changes>
- [ ] <Specs index: test suite column filled for every capability>
- [ ] <Verification: typecheck and test commands pass>

## Scenario delta

| Change | Scenario ID | Scenario | Notes |
|---|---|---|---|
| Added | `<capability>.01`–`<capability>.NN` | All scenarios of `<domain>/<capability>` | Backfilled from <sources> |
| Migrated | `<capability>.NN` | <title> | From legacy `<path>` (`<ticket>`) |
| Not migrated | — | <legacy scenario title> | <contradicted by current code: evidence> |
