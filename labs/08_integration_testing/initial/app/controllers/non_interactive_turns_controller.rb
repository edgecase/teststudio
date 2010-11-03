class NonInteractiveTurnsController < ApplicationController
  include NumberSource

  assume(:game) { Game.find(params[:game_id]) }
  assume(:current_player) { game.current_player }
  assume(:most_recent_turn) { nil }

  def start
    current_player.roller = Roller.new(number_source)
    current_player.take_turn
    current_player.save_turn!
    redirect_to non_interactive_results_path(game.id)
  end

  def results
    self.most_recent_turn = [current_player.turns.last]
  end
end
