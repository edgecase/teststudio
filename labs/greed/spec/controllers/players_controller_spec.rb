require 'spec_helper'

describe PlayersController do

  describe "GET index" do
    let!(:game) { make_findable(:game) }
    before {
      get :index, :game_id => game.id
    }

    it "finds the game" do
      @controller.send(:game).should == game
    end
    it "gets a list of auto players" do
      assigns[:players].should be_a Array
      assigns[:players].should all_be_respond_to(:name)
    end
  end

  describe "POST create" do
    let!(:game) {
      make_findable(:game).tap { |g|
        g.players << [Factory.build(:human_player)]
      }
    }
    let(:game_params) { { :game_id => game.id } }
    let(:params) { game_params }

    context "with a blank strategy" do
      before { post :create, params }
      it { response.should redirect_to(game_players_path(game)) }
      it "has a flash error message" do
        flash[:error].should =~ /select at least one.*player/i
      end
    end

    context "with a good strategy" do
      let(:params) { game_params.merge(:player => "ConservativeStrategy") }
      before {
        flexmock(game).should_receive(:save).once.
        and_return(true)
        post :create, params
      }

      subject { game }

      it { response.should redirect_to(start_turn_path(game)) }
      its(:current_player) { should == game.players.first }
      it {
        game.players.last.name.should == "Conservative" }
    end
  end

end
