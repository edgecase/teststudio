class Game < ActiveRecord::Base
  has_many :players
  belongs_to :current_player, :class_name => "Player"
  
  def start_game
    self.current_player = players.first
  end
  
  def next_player
    prev = nil
    players.each do |p|
      return p if current_player == prev
      prev = p
    end
    players.first
  end
end
