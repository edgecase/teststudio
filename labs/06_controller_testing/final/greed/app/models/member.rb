class Member < ActiveRecord::Base
  attr_accessible :email, :name, :rank

  validates_presence_of :name, :email, :rank
  validates_length_of :name, minimum: 3
  validates_format_of :email, with: RFC822::LooseEmailAddress,
    message: "must be a well-formed email address"
  validates_numericality_of :rank, only_integer: true

  def self.by_rank
    order("rank DESC")
  end

  def self.by_name
    order("name")
  end

  def wins_against(opponent)
    self.rank = new_rank(1.0, opponent)
  end

  def loses_against(opponent)
    self.rank = new_rank(0.0, opponent)
  end

  private

  def new_rank(score, opponent)
    (rank + 32 * (score - win_percent(opponent))).round
  end

  def win_percent(opponent)
    1.0 / (1 + 10**((opponent.rank - rank) / 400.0))
  end
end
