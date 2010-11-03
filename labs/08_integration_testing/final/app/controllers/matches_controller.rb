class MatchesController < ApplicationController
  assume(:members) { Member.by_name }
  assume(:match) { Match.new }

  def new
  end

  def create
    winner = Member.find(params[:match][:winner_id])
    loser  = Member.find(params[:match][:loser_id])
    self.match = Match.record_match(winner, loser)
    redirect_to members_path
  end
end
