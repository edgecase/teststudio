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
    Given { flexmock(Member).should_receive(:find_by_id).with(winner.id).and_return(winner) }
    Given { flexmock(Member).should_receive(:find_by_id).with(loser.id).and_return(loser) }
    Given { flexmock(Member).should_receive(:find_by_id).with(//).and_return(nil) }

    context "with good data" do
      Given { winner.should_receive(:save).once.and_return(true) }
      Given { loser.should_receive(:save).once.and_return(true) }

      When { post :create, "winner_id" => winner.id, "loser_id" => loser.id }

      Then { response.should redirect_to(members_path) }
      Then { winner.rank.should == 1016 }
      Then { loser.rank.should == 984 }
      Then { flash[:alert].should =~ /game.*recorded/i }
    end

    context "with bad data" do
      Given { flexmock(Member, :by_name => [:member]) }
      Given(:winner_id) { winner.id }
      Given(:loser_id) { loser.id }

      When { post :create, "winner_id" => winner_id, "loser_id" => loser_id }

      context "with no winner selected" do
        Given(:winner_id) { nil }
        Then { response.should render_template("new") }
        Then { assigns(:game).should be_a(Game) }
        Then { assigns(:members).should == [:member] }
      end

      context "with no loser selected" do
        Given(:loser_id) { nil }
        Then { response.should render_template("new") }
        Then { assigns(:game).should be_a(Game) }
        Then { assigns(:members).should == [:member] }
      end

      context "with winner and loser the same" do
        Given(:winner_id) { winner.id }
        Given(:loser_id) { winner.id }
        Then { response.should render_template("new") }
        Then { assigns(:game).should be_a(Game) }
        Then { assigns(:members).should == [:member] }
      end
    end
  end
end
