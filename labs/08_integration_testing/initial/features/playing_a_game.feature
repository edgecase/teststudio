Feature: Play a game
  As a user, 
  I would like to play a game of Greed against the computer
  So that I can have fun.

  Scenario: Default page 
    Given I go to the homepage
    Then I should see "Your Name"

  Scenario: Adding players to a page
    Given I go to the homepage
    When I fill in "game_name" with "John"
    And I press "Next"
    Then I am asked to choose players
    
  Scenario: Creating the game as a whole
    Given I go to the homepage
    When I fill in "game_name" with "John"
    And I press "Next"
    And I choose "ConservativeStrategy"
    And I press "Play"
    Then I should see "Conservative"
    And I should see "John"

  Scenario: A Human Player Rolls Once
    Given a fresh start
    And the dice will roll 1,2,5,4,3
    And I start a game
    Then the turn score so far is 150

  Scenario: A Human Player Rolls Once and Holds
    Given a fresh start
    And the dice will roll 1,2,5,4,3
    And I start a game
    When I choose to hold
    Then John's game score is 150
    And it is Conservative's turn

  Scenario: A Human Player Rolls And Goes Bust
    Given a fresh start
    And the dice will roll 4,2,3,4,3
    And I start a game
    Then I go bust

  Scenario: A Human Player Continues after Going Bust
    Given a fresh start
    And the dice will roll 4,2,3,4,3
    And I start a game
    When I continue
    Then it is Conservative's turn

  Scenario: A Human Player Rolls And Rerolls
    Given a fresh start
    And the dice will roll 1,2,3,4,3
    And the dice will roll 5,5,3,4
    And the dice will roll 5,5,3,4
    And I start a game
    When I choose to roll again
    Then it is my turn
    And 4 dice are displayed
    And the turn score so far is 200

  @wip
  Scenario: A Human Player Rolls And Goes Bust on Second Roll
    Given a fresh start
    And the dice will roll 2,3,4,6,3
    And the dice will roll 1,2,3,4,3
    And the dice will roll 2,3,4,6
    And I start a game
    And I take a turn
    When I choose to roll again
    Then it is my turn
    And 4 dice are displayed
    And the turn score so far is 0

 Scenario: The Computer Player Wins
    Given a fresh start
    And the dice will roll 2,2,3,3,4
    And the dice will roll 1,1,1,2,2
    And the dice will roll 2,2,3,3,4
    And the dice will roll 1,1,1,2,2
    And the dice will roll 2,2,3,3,4
    And the dice will roll 1,1,1,2,2
    And I start a game
    And I continue
    And I take a turn
    And I continue
    And I take a turn
    And I continue
    And I take a turn
    Then Conservative wins the game

  Scenario: The Human Player Wins
    Given a fresh start
    And the dice will roll 1,1,1,5,5
    And the dice will roll 1,1,1,5,5
    And the dice will roll 1,1,1,5,5
    And I start a game
    And I choose to roll again
    And I choose to roll again
    And I choose to hold
    Then John wins the game
