Feature: Flows with conditions
  In order to have finer grained control of what flows are active
  I want to specify boolean conditions on flow expressions

  Scenario: mutually exclusive flows
    Given I have the flows:
    """
    flow :steps,    settings.one,
                    settings.two,
                    settings.three

    flow :mess,     settings.two { not in_any_flow? },
                    settings.one
    """
    When I visit "/settings/one"
    And I follow "Next"
    When I follow "Next"
    Then I should be at "/settings/three"
    When I visit "/settings/two"
    When I follow "Next"
    Then I should be at "/settings/three"
    And I should not see "Next"
