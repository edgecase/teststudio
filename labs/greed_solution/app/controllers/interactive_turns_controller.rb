class InteractiveTurnsController < ApplicationController
  def human_start_turn
    setup_page_data
    @game.current_player.roller = roller
    @game.current_player.start_turn
    @game.current_player.roll_dice
    @game.current_player.save!
    redirect_to human_turn_interactive_turn_path(@game)
  end

  def human_holds
    setup_page_data
    @game.current_player.holds
    @game.current_player.save!
    if @game.current_player.score >= 3000
      @winner = @game.current_player.name
      render :template => "common/game_over"
    else
      redirect_to start_turn_path(@game)
    end
  end

  def human_rolls
    setup_page_data
    @game.current_player.roller = roller
    @game.current_player.rolls_again
    @game.current_player.save!
    redirect_to human_turn_interactive_turn_path(@game)
  end

  def human_turn
    setup_page_data
    @rolls = @game.current_player.turns.last.rolls
  end

  private

  def setup_page_data
    @game = Game.find(params[:id])
  end

  def roller
    @roller ||= create_roller
  end

  def create_roller
    simulated_source = SimulatedData.new(sim_data)
    random_source = RandomSource.new
    source = PriorityDataSource.new(simulated_source, random_source)
    Roller.new(source)
  end

  def sim_data
    session[:simulation] ||= []
  end
end
