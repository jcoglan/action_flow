Feature: Use arrays instead of '+' to manage alternatives that reference flows using symbols
  
  Background:
    Given I have the flows:
    """
    flow :has_alternates, [:start, anything.action]
    flow :start,          settings.one
    """
  
  Scenario: Enter a flow when I match a group of alternatives
    When I visit "/settings/one"
    Then I should see "In the alternatives flow"
  
