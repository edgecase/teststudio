Factory.define :two_player_game, :class => Game do |g|
  g.players { [Factory.build(:human_player), Factory.build(:computer_player)] }
end

Factory.define :empty_game, :class => Game do |g|
  g.players []
end
