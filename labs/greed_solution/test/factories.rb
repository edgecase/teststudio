Factory.define :face do |f|
  f.value 1
end

Factory.define :roll do |r|
  r.faces( (1..5).map { Factory.build(:face) } )
end

Factory.define :turn do |t|
  t.rolls [Factory.build(:roll)]
end
    
Factory.define :human_player do |hp| 
  hp.name Faker::Name.first_name
  hp.turns [Factory.build(:turn)]
end

Factory.define :computer_player do |cp|
  cp.strategy "Connie"
end

Factory.define :game do |g|
  g.human_player Factory.build(:human_player)
  g.computer_player Factory.build(:computer_player)
end

Factory.define :two_player_game, :class => Game do |g|
  g.players { [Factory.build(:human_player), Factory.build(:computer_player)] }
end

Factory.define :empty_game, :class => Game do |g|
  g.players []
end
