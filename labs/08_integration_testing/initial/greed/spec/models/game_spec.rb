require 'spec_helper'

describe Game do
  Given(:winner) { Member.new(name: "Jim", rank: 1000) }
  Given(:loser)  { Member.new(name: "Bob", rank: 1000) }
  Given(:game) { Game.new(winner: winner, loser: loser) }

  When { game.update_ranks }

  Then { winner.rank.should == 1016 }
  Then { loser.rank.should == 984 }
end
