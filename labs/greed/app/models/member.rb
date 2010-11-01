class Member < ActiveRecord::Base
  validates_presence_of :name, :email, :rank
  validates_uniqueness_of :email
  validates_numericality_of :rank, :only_integer => :true
  validates_length_of :name, :within => 3..1000, :message => "needs at least 3 characters"
  validates_format_of :email, :with => RFC822::LooseEmailAddress

  scope :by_rank, order("rank DESC", :name, :email)

  def draws_against(opponent_rank)
    self.rank = new_rank(0.5, opponent_rank)
  end

  def wins_against(opponent_rank)
    self.rank = new_rank(1, opponent_rank)
  end

  def loses_against(opponent_rank)
    self.rank = new_rank(0, opponent_rank)
  end

  private

  def new_rank(actual_score, opponent_rank)
    expected_score = 1.0 / (1 + 10**((opponent_rank - rank) / 400.0))
    rank + (32 * (actual_score - expected_score)).round
  end
end
