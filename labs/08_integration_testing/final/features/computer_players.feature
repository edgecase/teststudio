Feature: Computer players
  The computer players will play automatically
  
  Scenario: will see computers turn first
    Given I start a game
    Then I should see "Your Turn"
#    Then I should see "Conservative's Turn"
