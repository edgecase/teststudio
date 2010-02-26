class GamesController < ApplicationController
  def new
  end

  def create
    @human_player = HumanPlayer.new(params[:game])
    @game = Game.new(:human_player => @human_player)
    if @game.human_player.save && @game.save
      session[:game] = @game.id
      redirect_to choose_players_game_path(@game)
    else
      flash[:error] = "Can not create game\n"
      flash[:error] << @human_player.errors.full_messages.join(', ')
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
      @game.computer_player = ComputerPlayer.new(:strategy => strategy_name)
      @game.save
      redirect_to computer_turn_play_path(@game)
    end
  end
end
