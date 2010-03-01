class TurnsController < ApplicationController
  def start_turn
    game = Game.find(params[:game])
    game.current_player = game.next_player
    game.save!
    case game.current_player.play_style
    when :interactive
      game.current_player.start_turn
      game.current_player.save!
      redirect_to roll_interactive_turn_path(game.id)
    when :automatic
      redirect_to computer_turn_non_interactive_turn_path(game.id)
    end
  end

  def game_over
    @game = Game.find(params[:game])
    @winner = @game.current_player.name
  end
end
