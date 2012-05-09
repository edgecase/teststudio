require 'spec_helper'

describe GamesController do

  describe "GET new" do
    Given { flexmock(Member, :by_name => [:member]) }

    When { get :new }

    Then { response.code.should == "200" }
    Then { assigns(:game).should be_a(Game) }
    Then { assigns(:members).should == [:member] }
  end

  describe "POST create" do
    Given(:winner) { Member.new(rank: 1000).tap { |m| flexmock(m, id: "1") } }
    Given(:loser) { Member.new(rank: 1000).tap { |m| flexmock(m, id: "2") } }
    Given { flexmock(Member).should_receive(:find).with("1").and_return(winner) }
    Given { flexmock(Member).should_receive(:find).with("2").and_return(loser) }
    Given { winner.should_receive(:save).once.and_return(true) }
    Given { loser.should_receive(:save).once.and_return(true) }

    When { post :create, "winner_id" => winner.id, "loser_id" => loser.id }

    Then { response.should redirect_to(members_path) }
    Then { winner.rank.should == 1016 }
    Then { loser.rank.should == 984 }
  end

end
