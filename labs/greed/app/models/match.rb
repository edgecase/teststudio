class Match < ActiveRecord::Base
  belongs_to :winner, :class_name => "Member"
  belongs_to :loser, :class_name => "Member"

  validates_presence_of :winner, :loser, :played_on

  validate :must_be_different

  def must_be_different
    errors.add(:base, "Winner and loser must be different") unless winner != loser
  end

  scope :played_by, lambda { |member|
    where("loser_id = ? OR winner_id = ?", member.id, member.id)
  }

  def self.record_match(winner, loser)
    attrs = { :winner => winner, :loser => loser, :played_on => Date.today }
    match = Match.new(attrs)
    winner.wins_against(loser.rank)
    loser.loses_against(winner.rank)
    Match.transaction do
      winner.save &&
        loser.save &&
        match.save
    end
    match
  end
end
