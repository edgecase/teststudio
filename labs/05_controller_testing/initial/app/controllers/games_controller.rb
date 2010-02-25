class GamesController < ApplicationController
  def new
  end

  def create
    @human_player = HumanPlayer.new(params[:game])
    @game = Game.new(:human_player => @human_player)
    if @game.human_player.save && @game.save
      session[:game] = @game.id
      redirect_to choose_players_game_path(@game)
    else
      flash[:error] = "Can not create game\n"
      flash[:error] << @human_player.errors.full_messages.join(', ')
      redirect_to new_game_path
    end
  end

  def choose_players
    # IMPLEMENT THE CODE FOR THIS CONTOLLER
  end

  def assign_players
    @game = Game.find(params[:id])
    strategy_name = params[:player] || []
    if strategy_name.blank?
      flash[:error] = "Please select at least one computer player"
      redirect_to choose_players_game_path(@game)
    else
      @game.computer_player = ComputerPlayer.new(:strategy => strategy_name)
      @game.save
      redirect_to computer_turn_game_path(@game)
    end
  end

  def computer_turn
    setup_page_data
    cp = @game.computer_player
    cp.roller = roller
    turn = cp.take_turn
    cp.score += turn.score
    cp.save
    redirect_to computer_turn_results_game_path(@game)
  end

  def computer_turn_results
    setup_page_data
    if @game.computer_player.score >= 3000
      @winner = @game.computer_player.name
      render :action => "game_over"
    else
      @turn_histories = [@game.computer_player.turns.last]
    end
  end

  def human_start_turn
    setup_page_data
    @game.human_player.roller = roller
    @game.human_player.start_turn
    @game.human_player.roll_dice
    @game.human_player.save!
    redirect_to human_turn_game_path(@game)
  end

  def human_holds
    # WRITE THIS ACTION
  end

  def human_rolls
    # WRITE THIS ACTION
  end

  def human_turn
    # WRITE THIS ACTION
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
