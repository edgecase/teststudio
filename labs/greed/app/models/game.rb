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

  def over?
    players.any? { |p| winner?(p) }
  end

  def winner
    players.detect { |p| winner?(p) }
  end

  def winner?(player)
    player.score >= 3000
  end
end
