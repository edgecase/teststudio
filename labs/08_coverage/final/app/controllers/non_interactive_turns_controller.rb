class NonInteractiveTurnsController < ApplicationController
  include SimInjectionRoller

  def start
    @game = Game.find(params[:id])
    cp = @game.current_player
    cp.roller = roller
    turn = cp.take_turn
    cp.score += turn.score
    cp.save
    redirect_to results_non_interactive_turn_path(@game)
  end

  def results
    @game = Game.find(params[:id])
    if @game.current_player.score >= 3000
      @winner = @game.current_player.name
      redirect_to game_over_path(@game)
    else
      @most_recent_turn = [@game.current_player.turns.last]
    end
  end
end
