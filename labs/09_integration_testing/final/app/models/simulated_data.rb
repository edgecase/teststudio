class SimulatedData
  def initialize(queued_numbers)
    @queued_numbers = queued_numbers
  end

  def random_numbers(n)
    numbers = @queued_numbers.shift
    if numbers
      numbers[0...n]
    else
      nil
    end
  end
end
