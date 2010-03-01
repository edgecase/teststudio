class InteractiveTurnsController < ApplicationController
  def roll
    @game = Game.find(params[:id])
    @game.current_player.roller = roller
    roll_result = @game.current_player.roll_dice
    @game.current_player.save!
    action = @game.current_player.turns.last.rolls.last.action
    if roll_result == :bust
      redirect_to bust_interactive_turn_path(@game)
    else
      redirect_to decide_interactive_turn_path(@game)
    end
  end
  
  def bust
    @game = Game.find(params[:id])
    @rolls = @game.current_player.turns.last.rolls
  end

  def decide
    @game = Game.find(params[:id])
    @rolls = @game.current_player.turns.last.rolls
  end
  
  def hold
    @game = Game.find(params[:id])
    @game.current_player.holds
    @game.current_player.save!
    if @game.current_player.score >= 3000
      redirect_to game_over_path(@game)
    else
      redirect_to start_turn_path(@game)
    end
  end

  private

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
