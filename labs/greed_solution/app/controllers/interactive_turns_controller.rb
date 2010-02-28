class InteractiveTurnsController < ApplicationController
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

  def human_start_turn
    setup_page_data
    @game.human_player.roller = roller
    @game.human_player.start_turn
    @game.human_player.roll_dice
    @game.human_player.save!
    redirect_to human_turn_interactive_turn_path(@game)
  end

  def human_holds
    setup_page_data
    @game.human_player.holds
    @game.human_player.save!
    if @game.human_player.score >= 3000
      @winner = @game.human_player.name
      render :template => "common/game_over"
    else
      redirect_to start_turn_path(@game, @game.computer_player)
    end
  end

  def human_rolls
    setup_page_data
    @game.human_player.roller = roller
    @game.human_player.rolls_again
    @game.human_player.save!
    redirect_to human_turn_interactive_turn_path(@game)
  end

  def human_turn
    setup_page_data
    @rolls = @game.human_player.turns.last.rolls
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
