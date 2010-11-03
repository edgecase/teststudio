require 'spec_helper'

describe GamesController do

  describe "GET new" do
    it "renders the new view" do
      get :new
      response.should render_template("new")
    end
  end

  describe "POST create" do
    let!(:game) { Factory.build(:game) }
    let!(:human) { Factory.build(:human_player, :name => "Bob") }
    let(:params) { { :game => { :name => human.name } } }

    before do
      flexmock(HumanPlayer).should_receive(:new).
        with("name" => human.name).
        and_return(human).once
      flexmock(Game, :new => game)
    end

    def post_to_create
      post :create, params
    end

    subject { game }

    context "with good save" do
      before { post_to_create }

      its(:players) { should include(human) }
      it { response.should redirect_to(game_players_path(game)) }
    end

    context "with bad save on game" do
      before do
        make_invalid(game)
        post_to_create
      end
      it { response.should redirect_to(new_game_path) }
      it "sets the flash error message" do
        flash[:error].should =~ /can not create game/i
      end
    end

    context "with bad save on human" do
      before do
        make_invalid(human, "boogey man")
        post_to_create
      end
      it { response.should redirect_to(new_game_path) }
      it "flash message should include human error messages" do
        flash[:error].should =~ /can not create game/i
        flash[:error].should =~ /boogey man/i
      end
    end
  end
end
