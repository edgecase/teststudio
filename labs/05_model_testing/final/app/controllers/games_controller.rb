class GamesController < ApplicationController
  assume(:game) { }

  def new
  end

  def create
    self.game = Game.new
    human = HumanPlayer.new(params[:game])
    game.players << human

    if game.save
      redirect_to game_players_path(game)
    else
      flash[:error] = "Can not create game\n"
      flash[:error] << human.errors.full_messages.join(", ")
      redirect_to new_game_path
    end
  end
end
