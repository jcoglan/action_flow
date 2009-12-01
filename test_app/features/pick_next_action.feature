Feature: Picking next action based on session history
  
  Scenario: Getting a redirect automatically
    Given I am on the new user page
    And I fill in "Username" with "jcoglan"
    And I press "Save"
    Then I should be on the home page
    And I should see "Welcome!"
  
  Scenario: No redirect at end of flow
    Given I am on the contact importer page
    Then I should not see "Step 2 of settings"
    When I follow "Gmail"
    And I press "Import"
    Then I should see "We imported your contacts"
  
  Scenario: Reusing a flow within another
    Given I am on the settings page
    And I follow "Skip this step"
    Then I should see "Step 2 of settings"
    When I follow "Gmail"
    And I press "Import"
    Then I should be on the home page
    And I should see "Welcome!"

