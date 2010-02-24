class Game < ActiveRecord::Base
  has_one :human_player
  has_one :computer_player

  def players
    [computer_player, human_player]
  end
end
