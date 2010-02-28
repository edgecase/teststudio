class NonInteractiveTurnsController < ApplicationController
  def computer_turn
    setup_page_data
    cp = @game.computer_player
    cp.roller = roller
    turn = cp.take_turn
    cp.score += turn.score
    cp.save
    redirect_to computer_turn_results_non_interactive_turn_path(@game)
  end

  def computer_turn_results
    setup_page_data
    if @game.computer_player.score >= 3000
      @winner = @game.computer_player.name
      render :template => "common/game_over"
    else
      @most_recent_turn = [@game.computer_player.turns.last]
    end
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
