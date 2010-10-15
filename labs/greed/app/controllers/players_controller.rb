class PlayersController < ApplicationController
  assume(:game) { Game.find(params[:game_id]) }
  assume(:players) { AutoPlayer.players }

  def index
  end

  def create
    if params[:player].blank?
      flash[:error] = "Please select at least one computer player"
      redirect_to game_players_path(game)
    else
      cp = ComputerPlayer.new
      cp.strategy = params[:player]
      game.players << cp
      game.current_player = game.players.first
      game.save
      redirect_to start_turn_path(game)
    end
  end
end
