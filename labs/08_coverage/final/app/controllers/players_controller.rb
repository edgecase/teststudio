class PlayersController < ApplicationController
  def index
    @game = Game.find(params[:game_id])
    @players = AutoPlayer.players
  end

  def create
    @game = Game.find(params[:game_id])
    strategy_name = params[:player] || []
    if strategy_name.blank?
      flash[:error] = "Please select at least one computer player"
      redirect_to game_players_path(@game)
    else
      cp = ComputerPlayer.new(:strategy => strategy_name, :position => 1)
      @game.players << cp
      @game.current_player = @game.players.first
      @game.save
      redirect_to start_turn_path(@game)
    end
  end
end
