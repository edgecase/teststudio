class GamesController < ApplicationController
  def new
  end

  def create
    @game = Game.new
    human_player = HumanPlayer.new(params[:game])
    @game.players << human_player
    if @game.save
      session[:game] = @game.id
      redirect_to game_players_path(@game)
    else
      flash[:error] = "Can not create game\n"
      flash[:error] << human_player.errors.full_messages.join(', ')
      redirect_to new_game_path
    end
  end
end
