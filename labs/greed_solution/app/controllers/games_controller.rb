class GamesController < ApplicationController
  def new
  end

  def create
    @game = Game.new
    human_player = HumanPlayer.new(params[:game])
    @game.players << human_player
    if @game.save
      session[:game] = @game.id
      redirect_to choose_players_game_path(@game)
    else
      flash[:error] = "Can not create game\n"
      flash[:error] << human_player.errors.full_messages.join(', ')
      redirect_to new_game_path
    end
  end

  def choose_players
    @game = Game.find(params[:id])
    @players = AutoPlayer.players
  end

  def assign_players
    @game = Game.find(params[:id])
    strategy_name = params[:player] || []
    if strategy_name.blank?
      flash[:error] = "Please select at least one computer player"
      redirect_to choose_players_game_path(@game)
    else
      cp = ComputerPlayer.new(:strategy => strategy_name, :position => 1)
      @game.players << cp
      @game.current_player = @game.players.first
      @game.save
      redirect_to start_turn_path(@game)
    end
  end
end
