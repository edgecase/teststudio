class PlayersController < ApplicationController
  def index
    @players = AutoPlayer.players
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

  def game
    @game ||= Game.find(params[:game_id])
  end
end
