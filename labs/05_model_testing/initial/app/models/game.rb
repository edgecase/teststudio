class Game < ActiveRecord::Base
  has_many :players
  belongs_to :current_player, :class_name => "Player"

  def start
    self.current_player = nil
  end

  def next_player
    found = false
    players.each do |p|
      return p if found
      found = p == current_player
    end
    players.first
  end
end
