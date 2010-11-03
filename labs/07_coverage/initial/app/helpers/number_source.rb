module NumberSource
  class SimulatedSource
    def initialize(numbers)
      @numbers = numbers
      @random_source = RandomSource.new
    end

    def random_numbers(n)
      numbers = @numbers.shift
      if numbers
        numbers[0,n]
      else
        @random_source.random_numbers(n)
      end
    end
  end

  def number_source
    if session[:simulation]
      SimulatedSource.new(session[:simulation])
    else
      RandomSource.new
    end
  end
end
