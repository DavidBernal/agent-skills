Feature: <Capability name>
  As a <role>
  I want <capability>
  So that <benefit>

  Endpoint: <entry points that expose this capability, if any>

  Current rules
  - <Durable business rule, as it holds today> [<ID>]
  - <Rule refined by a later change> [<ID>, <ID>]

  Background:
    Given <shared precondition>

  # <Group of related rules>

  @<capability>.01 @<ID>
  Scenario: <happy path>
    Given <state>
    When <action>
    Then <observable outcome>

  @<capability>.02 @<ID>
  Scenario: <validation error>
    Given <state>
    When <invalid action>
    Then <error feedback>
    And <nothing is persisted>

  @<capability>.03 @<ID> @<later-ID>
  Scenario Outline: <rule with variations>
    Given <state with "<input>">
    When <action>
    Then <outcome "<result>">

    Examples:
      | input | result |
      | ...   | ...    |
