Feature: Mutually exclusive flows
  In order to simplify managment of overlapping flows
  I want to mark sets of flows as mtually exclusive
  
  Background:
    Given I have the flows:
    """
    flow :one, settings.one,
               settings.two
    
    flow :two, settings.two
    
    flow :others, settings.four,
                  settings.five
    
    terminate :others, :on => settings.one
    
    mutex :one, :two, :others
    """
  
  Scenario: Don't enter a flow excluded by another
    When I visit "/settings/one"
    And I visit "/settings/two"
    Then I should see "In flow one"
    And I should not see "In flow two"
  
  Scenario: Locked flow becomes available after locking flow exits
    When I visit "/settings/one"
    And I visit "/settings/two"
    And I visit "/settings/three"
    And I visit "/settings/two"
    Then I should not see "In flow one"
    And I should see "In flow two"
  
  Scenario: Locked flow becomes available if it terminates another
    When I visit "/settings/four"
    And I visit "/settings/one"
    Then I should see "Flow number 1"

