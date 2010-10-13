class Player
  def turns
    [:x]
  end
end

describe Player do
  it { should have(1).turn }
end
