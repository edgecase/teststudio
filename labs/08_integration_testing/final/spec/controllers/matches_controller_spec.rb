require 'spec_helper'

describe MatchesController do

  describe "GET new" do
    before do
      flexmock(Member, :by_name => :members)
      flexmock(Match, :new => :match)
     get :new
    end
    it { should render_template("new") }
    specify { controller.members.should == :members }
    specify { controller.match.should == :match }
  end

  describe "POST create" do
    let(:winner) { make_findable(:member, :name => "Winner", :rank => 1100) }
    let(:loser)  { make_findable(:member, :name => "Loser",  :rank =>  900) }
    let(:match)  { Factory(:match) }
    let(:attrs)  { { "winner_id" => winner.id, "loser_id" => loser.id } }
    let(:new_attrs) { { :winner => winner, :loser => loser, :played_on => Date.today } }

    before do
      expect_new(match, new_attrs)
      expect_save(match)
      post :create, :match => attrs
    end

    it { should redirect_to members_path }
    specify { winner.rank.should > 1100 }
    specify { loser.rank.should <  900 }
  end

end
