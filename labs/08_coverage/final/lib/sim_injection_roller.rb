
# Support methods for using a roller that allows simulated data to be
# injected via the session.  This roller allows testing via cucumber.
module SimInjectionRoller

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
