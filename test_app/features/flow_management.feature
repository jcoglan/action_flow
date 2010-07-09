Feature: Manage flow transitions

  Background: Setup default flows
    Given I have the flows:
    """
    flow :steps,    settings.one,
                    settings.two,
                    settings.three

    flow :large,    settings.four,
                    settings.five,
                    settings.six,
                    settings.seven,
                    settings.eight

    flow :process,  settings.intro + application.other,
                    :steps,
                    settings.outro(:id => find(:text))

    flow :pass,     settings.passthrough,
                    settings.intro
    """
  
  Scenario: Simple flow sequence terminated at end
    When I visit "/settings/one"
    And I follow "Next"
    Then I should be at "/settings/two"
    When I follow "Next"
    Then I should be at "/settings/three"
    And I should not see "Next"
  
  Scenario: One sequence nested inside another
    When I visit "/settings/intro"
    And I follow "Next"
    Then I should be at "/settings/one"
    When I follow "Next"
    Then I should be at "/settings/two"
    When I follow "Next"
    Then I should be at "/settings/three"
    When I follow "Next"
    Then I should be at "/settings/outro"
  
  Scenario: Skipping the outer sequence from the controller
    When I visit "/settings/intro"
    And I follow "Next"
    Then I should be at "/settings/one"
    When I visit "/settings/two?skip=true"
    Then I should be at "/settings/outro"
  
  Scenario: Skip a subflow
    When I visit "/settings/intro"
    And I follow "Next"
    And I follow "Skip"
    Then I should be at "/settings/outro"
  
  Scenario: Get partway through a subflow before skipping
    When I visit "/settings/intro"
    And I follow "Next"
    And I follow "Next"
    And I follow "Skip"
    Then I should be at "/settings/outro"
  
  Scenario: Get to the final page of a subflow before skipping
    When I visit "/settings/intro"
    And I follow "Next"
    And I follow "Next"
    And I follow "Next"
    And I follow "Skip"
    Then I should be at "/settings/outro"
  
  Scenario: Pass through variables to flow expressions
    When I visit "/settings/intro/Hello"
    And I follow "Next"
    And I follow "Skip"
    Then I should be at "/settings/outro/Hello"
    Then I should see "Hello"
  
  Scenario: Last page of a flow is still part of the flow
    When I visit "/settings/intro"
    Then I should see "You're in the :process flow"
    When I follow "Next"
    And I follow "Skip"
    Then I should see "You're in the :process flow"
    When I visit "/settings/outro"
    Then I should see "You're in the :process flow"
  
  Scenario: Backtracking still picks the right next action
    When I visit "/settings/one"
    And I follow "Next"
    When I follow "Next"
    Then I should be at "/settings/three"
    When I visit "/settings/two"
    When I follow "Next"
    Then I should be at "/settings/three"
  
  Scenario: Skip back and forth between visited pages
    When I visit "/settings/four"
    And I follow "Next"
    And I follow "Next"
    And I follow "Next"
    Then I should be at "/settings/seven"
    When I visit "/settings/five"
    And I follow "Next"
    Then I should be at "/settings/six"
    When I visit "/settings/five"
    And I visit "/settings/seven"
    And I follow "Next"
    Then I should be at "/settings/eight"
  
  Scenario: Pass params through #next_in_flow
    When I visit "/settings/passthrough/milk"
    Then I should see "Received milk"
  
  Scenario: Session contains invalid objects
    Given I visit "/settings/poison"
    And I visit "/settings/one"
  
  Scenario: Session contains data for nonexistent flows
    Given I visit "/settings/delete"
    And I visit "/settings/one"
    Then I should see "This is a step"

