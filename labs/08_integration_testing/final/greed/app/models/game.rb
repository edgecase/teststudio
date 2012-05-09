class Game
  attr_accessor :winner, :loser

  def initialize(options={})
    @winner = options[:winner]
    @loser = options[:loser]
  end

  def update_ranks
    winners_rank = @winner.rank
    losers_rank = @loser.rank
    @winner.wins_against(losers_rank)
    @loser.loses_against(winners_rank)
  end

  def save
    @winner.save
    @loser.save
  end
end
