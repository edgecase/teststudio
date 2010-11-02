class Match < ActiveRecord::Base
  belongs_to :winner, :class_name => "Member"
  belongs_to :loser, :class_name => "Member"

  validates_presence_of :winner, :loser, :played_on

  validate :must_be_different

  def must_be_different
    errors.add(:base, "Winner and loser must be different") unless winner != loser
  end

  scope :played_by, lambda { |member|
    where("loser_id = ? OR winner_id = ?", member.id, member.id).
    order("played_on ASC, created_at ASC")
  }

  def self.record_match(winner, loser)
    match = Match.new(
      :winner => winner,
      :winner_old_rank => winner.rank,
      :loser => loser,
      :loser_old_rank => loser.rank,
      :played_on => Date.today)
    winner.wins_against(loser.rank)
    loser.loses_against(winner.rank)
    match.winner_new_rank = winner.rank
    match.loser_new_rank = loser.rank
    Match.transaction do
      winner.save &&
        loser.save &&
        match.save
    end
    match
  end
end
