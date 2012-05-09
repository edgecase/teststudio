class GamesController < ApplicationController
  def new
    setup_for_new
  end

  def create
    if params[:winner_id].blank? || params[:loser_id].blank?
      flash.now[:error] = "Both winner and loser must be specified"
      setup_for_new
      render :new
    elsif params[:winner_id] == params[:loser_id]
      flash.now[:error] = "The winner and loser must be different"
      setup_for_new
      render :new
    else
      winner = Member.find(params[:winner_id])
      loser = Member.find(params[:loser_id])
      game = Game.new(winner: winner, loser: loser)
      game.update_ranks
      game.save
      redirect_to members_path
    end
  end

  private

  def setup_for_new
    @game = Game.new
    @members = Member.by_name
  end

end
