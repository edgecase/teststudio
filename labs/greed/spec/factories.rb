
# Make the default strategy :build globally.
def Factory.build_def(name, options={}, &block)
  opts = {:default_strategy => :build}.merge(options)
  Factory.define(name, opts, &block)
end

# --------------------------------------------------------------------

Factory.build_def :face do |face|
  face.position 1
  face.value { 3 }
end

# --------------------------------------------------------------------

Factory.build_def :roll do |roll|
  roll.position 1
  roll.faces { [] }
end

# --------------------------------------------------------------------

Factory.build_def :turn do |turn|
  turn.rolls { [] }
  turn.position 1
end

Factory.build_def :turn_ending_with_hold, :parent => :turn do |turn|
  turn.rolls { [
      Factory(:roll, :action => :roll),
      Factory(:roll, :action => :hold),
    ]
  }
end

Factory.build_def :turn_ending_with_unknown, :parent => :turn do |turn|
  turn.rolls { [
      Factory(:roll, :action => :roll),
      Factory(:roll, :action => nil),
    ]
  }
end

# --------------------------------------------------------------------

Factory.build_def :player do |player|
  player.name { Faker::Name.first_name }
  player.score 0
  player.strategy "ConservativeStrategy"
end

Factory.build_def(:computer_player,
  :parent => :player,
  :class => ComputerPlayer) do |player|
end

Factory.build_def(:human_player,
  :parent => :player,
  :class => HumanPlayer) do |player|
  player.name Faker::Name.first_name
end

# --------------------------------------------------------------------

Factory.build_def :game do |game|
  game.players []
end

Factory.build_def :game_between_human_and_computer, :parent => :game do |game|
  game.players {
    [
      Factory(:human_player, :score => 0),
      Factory(:computer_player, :score => 0, :strategy => "ConservativeStrategy")
    ]
  }
end
