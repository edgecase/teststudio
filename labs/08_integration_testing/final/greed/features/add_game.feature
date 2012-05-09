Feature: Add a Game

  As a member
  I want to add a game
  So that I can adjust my ranking

  Scenario: Add Game
    Given there is "A Winner" member
    And there is "A Loser" member
    And I am on the add game page

    When I select "A Winner" as the winner
    And I select "A Loser" as the loser
    And I click the "Record Game" button

    Then I see "A Winner" with a 1016 rank
    And I see "A Loser" with a 984 rank
