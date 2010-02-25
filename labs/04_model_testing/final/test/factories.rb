Factory.define :player do |p|
  p.name { Faker::Name.name }
  p.score 10
  p.strategy "Agressive"
end

Factory.define :face do |f|
  f.value { rand(6) + 1 }
  f.position 5
end
 