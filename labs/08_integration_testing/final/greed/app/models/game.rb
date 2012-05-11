class Game
  include ActiveRecord::Validations

  attr_accessor :winner, :loser

  validates_presence_of :winner, :loser
  validate :must_be_different_players

  def initialize(options={})
    @winner = options[:winner] || Member.find_by_id(options[:winner_id])
    @loser = options[:loser] || Member.find_by_id(options[:loser_id])
  end

  def update_ranks
    winners_rank = @winner.rank
    losers_rank = @loser.rank
    @winner.wins_against(losers_rank)
    @loser.loses_against(winners_rank)
  end

  def new_record?
    true
  end

  def save
    if valid?
      @winner.save
      @loser.save
    end
  end

  def must_be_different_players
    if winner && winner == loser
      errors[:base] << "Winner must be different than loser"
    end
  end
end
