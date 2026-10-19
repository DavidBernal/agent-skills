@status-planned
Feature: <Short feature name>
  As a <role>
  I want <capability>
  So that <benefit>

  Decision record
  - Context: <why this feature, what constraint or problem exists today>
  - Decision: <the approach chosen, in 1-3 lines>
  - Alternatives considered: <option> (discarded because <reason>)
  - Consequences: <trade-offs, follow-ups, what this makes harder>
  - Out of scope: <explicitly excluded items>

  Checklist
  - [ ] <Data: migration / model change>
  - [ ] <Server: action or endpoint with validation + authorization>
  - [ ] <UI: screens and states (empty, loading, error, success)>
  - [ ] <Tests: one automated test per scenario, traceable by @S id>
  - [ ] <Verification: typecheck and test commands pass>

  Background:
    Given <shared precondition>

  @S1
  Scenario: <happy path>
    Given <state>
    When <action>
    Then <observable outcome>

  @S2
  Scenario: <validation error>
    Given <state>
    When <invalid action>
    Then <error feedback>
    And <nothing is persisted>

  @S3
  Scenario Outline: <rule with variations>
    Given <state with "<input>">
    When <action>
    Then <outcome "<result>">

    Examples:
      | input | result |
      | ...   | ...    |
