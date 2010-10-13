
Factory.define :face do |face|
  face.position 1
  face.value { 3 }
end

Factory.define :roll do |roll|
  roll.position 1
  roll.faces []
end

Factory.define :turn do |turn|
  turn.position 1
end

Factory.define :game do |game|
  game.players []
end

Factory.define :player do |player|
  player.name { Faker::Name.first_name }
end

Factory.define(:computer_player,
  :parent => :player,
  :class => ComputerPlayer) do |player|
end

Factory.define :two_player_game, :parent => :game do |game|
  game.players { [Factory.build(:human_player), Factory.build(:computer_player)] }
end
