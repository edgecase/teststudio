Feature: Add a Game

  As a member
  I want to add a game
  So that I can adjust my ranking

  Scenario: Add Game
    Given there is "Winfred" member with rank 1000
    And there is "Larry" member with rank 1000
    And I am ready to add a game

    When I select "Winfred" as the winner
    And I select "Larry" as the loser
    And I record the game

    Then I see "Winfred" with a 1016 rank
    And I see "Larry" with a 984 rank
