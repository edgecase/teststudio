class GamesController < ApplicationController
  before_filter :find_members

  def new
    @game = Game.new
  end

  def create
    @game = Game.new(winner_id: params[:winner_id], loser_id: params[:loser_id])
    if @game.valid?
      @game.update_ranks
      @game.save
      redirect_to members_path, alert: "Game recorded: Winner is #{@game.winner.name}, Loser is #{@game.loser.name}"
    else
      render :new
    end
  end

  private

  def find_members
    @members = Member.by_name
  end

end
