class NonInteractiveTurnsController < ApplicationController
  assume(:game) { Game.find(params[:game_id]) }
  assume(:current_player) { game.current_player }
  assume(:most_recent_turn) { nil }

  def start
    current_player.take_turn
    current_player.save_roll!
    redirect_to non_interactive_results_path(game.id)
  end

  def results
    if current_player.score >= 3000
      redirect_to game_over_path(game)
    else
      self.most_recent_turn = [current_player.turns.last]
    end
  end
end
