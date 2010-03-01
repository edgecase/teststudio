class TurnsController < ApplicationController
  def start_turn
    game = Game.find(params[:game])
    game.current_player = game.next_player
    game.current_player.start_turn
    game.save!
    case game.current_player.play_style
    when :interactive
      redirect_to roll_interactive_turn_path(game.id)
    when :automatic
      redirect_to computer_turn_non_interactive_turn_path(game.id)
    end
  end
end
