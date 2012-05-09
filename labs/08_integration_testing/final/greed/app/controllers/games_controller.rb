class GamesController < ApplicationController
  def new
    @game = Game.new
    @members = Member.by_name
  end

  def create
    winner = Member.find(params[:winner_id])
    loser = Member.find(params[:loser_id])
    game = Game.new(winner: winner, loser: loser)
    game.update_ranks
    game.save
    redirect_to members_path
  end
end
