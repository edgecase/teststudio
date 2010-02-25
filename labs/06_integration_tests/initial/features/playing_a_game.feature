# This is the feature file describing the play of the Greed game on
# the web site.  A number of features are already defined.  Many more
# features are still be filled out.

Feature: Play a game
  As a user, 
  I would like to play a game of Greed agains the computer
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
    And I choose "Randy"
    And I press "Play"
    Then I should see "Randy"
    And I should see "John"

  Scenario: A Human Player Rolls Once
    Given a fresh start
    #
    # Since dice rolls are random and hard to test, the following
    # steps inject precalculated dice rolls into the system.  The
    # first roll (2,3,4,6,3) below is non-scoring, forcing the
    # computer player to go bust and given the human player a turn.
    # The second roll (1,2,5,4,3) will be the first roll the human
    # rolls.
    #
    And the dice will roll 2,3,4,6,3
    And the dice will roll 1,2,5,4,3
    And I start a game
    When I take a turn
    Then the turn score so far is 150

# The following scenarios are incomplete.  Please finish writing them.

  Scenario: A Human Player Rolls Once
    Given a fresh start
    And the dice will roll 2,3,4,6,3
    And the dice will roll 1,2,5,4,3
    And I start a game
    And I take a turn
    When I choose to hold
    # ---------------------------------------------------------------
    # FILL IN:
    # 
    # The above steps gets you through a complete human player turn.
    # Add some Then steps that (1) verify that John's score is now
    # 150, and (2) that it is now Connie's turn.  Look through the
    # steps definitions file
    # (features/step_definitions/greed_steps.rb) for hints.
    # ---------------------------------------------------------------
    Then # ...
    And  # ...

  Scenario: A Human Player Rolls And Goes Bust
    Given a fresh start
    And the dice will roll 2,3,4,6,3
    And the dice will roll 4,2,3,4,3
    # ---------------------------------------------------------------
    # FILL IN:
    # 
    # Here the second dice roll above insures that the human player
    # goes bust immediately.  Continue adding And steps to have the
    # human player start the game and take a turn.  Provide a Then
    # step that makes sure the human goes bust.
    # ---------------------------------------------------------------
    And # ... (start a game)
    And # ... (takes a turn)
    Then # ... (goes bust)

  # ==================================================================
  # The following scenarios are for you to complete as you see fit.
  # ==================================================================

  Scenario: A Human Player Continues after Going Bust
    # (make sure it is Connie's turn after the human player continues
    # after a bust)

  Scenario: A Human Player Rolls And Rerolls
    # (here the human player rolls again.  Show that the total score
    # is 200 (150 + 50) after he rolls again and that 4 dice are
    # shown.) 

  Scenario: The Computer Player Wins
    # Create a scenario where the computer player wins.  Stack the
    # dice so that the computer player gets a lot of high scoring
    # rolls.  Since Connie always holds, arrange it so that the human
    # player goes bust every turn and Connie gets triple ones.  Assert
    # that Connie wins the game.

  Scenario: The Human Player Wins
    # Similar to above, but arrange it so that the human player wins.
    # Give Connie a bust on the first roll, then keep feeding triple
    # ones to the human player (who rolls 3 times) for a win.  Assert
    # that John wins the game.

