Feature: Flows with conditions
  In order to have finer grained control of what flows are active
  I want to specify boolean conditions on flow expressions

  Scenario: Mutually exclusive flows
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
    
  Scenario: Terminate flow on given expression
    Given I have the flows:
    """
    flow :steps, settings.three
                         
    flow :mess, settings.two,
                settings.three,
                settings.four

    terminate :mess, :on => settings.five
    """
    When I visit "/settings/two"
    And I visit "/settings/five"
    And I visit "/settings/three"
    Then I am at the end of the "mess" flow

  Scenario: Specify list of flows to terminate flow on given expression
    Given I have the flows:
    """
    flow :flow_one, settings.one,
                    settings.two,
                    settings.five

    flow :flow_two, settings.four,
                    settings.five,
                    settings.two

    terminate :flow_one, :flow_two, :on => settings.seven
    """
    When I visit "/settings/one"
    And I visit "/settings/seven"
    And I visit "/settings/two"
    Then I am at the end of the "flow_two" flow
    When I visit "/settings/four"
    And I visit "/settings/seven"
    And I visit "/settings/five"
    Then I am at the end of the "flow_one" flow
