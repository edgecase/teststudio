class TurnsController < ApplicationController
  def start_turn
    game = Game.find(params[:game])
    player = Player.find(params[:player])
    case player.play_style
    when :interactive
      redirect_to human_start_turn_interactive_turn_path(game.id)
    when :automatic
      redirect_to computer_turn_non_interactive_turn_path(game.id)
    end
  end
end
