Feature: Picking next action based on session history
  
  Scenario: Getting a redirect automatically
    Given I am on the new user page
    And I fill in "Username" with "jcoglan"
    And I press "Save"
    Then I should be on the home page
    And I should see "Welcome!"

