Feature: Interactive Development Session

  Scenario: Starting a new project and committing changes
    Given I have started a new interactive session
    When I enter the command "start project MyProject"
    Then a new project called "MyProject" should be created
    When I enter the code "def my_function; end"
    And I enter the command "commit changes 'Initial commit'"
    Then the changes should be committed with the message "Initial commit"
