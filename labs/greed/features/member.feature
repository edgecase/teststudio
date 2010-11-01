Feature: Membership Management
  As a member, I wish to manage the members of the guild.       

  Scenario: Adding new Members
    Given I am on the members page
    When I follow "New member"
    Then I should see "New Member"
