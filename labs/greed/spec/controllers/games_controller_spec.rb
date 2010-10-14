require 'spec_helper'

describe GamesController do
  describe "GET new" do
    it "renders the new view" do
      get :new
      response.should render_template("new")
    end
  end

  describe "POST create" do
    before do
      @game = Factory.build(:game)
      @human = Factory.build(:human_player, :name => "Bob")
      flexmock(HumanPlayer).should_receive(:new).
        with("name" => @human.name).
        and_return(@human).once
      flexmock(Game, :new => @game)

    end
    subject { @game }

    context "with good save" do
      before do
        post :create, :game => { :name => @human.name }
      end

      its(:players) { should include(@human) }
      it { response.should redirect_to(game_players_path(@game)) }
    end

    context "with bad save on game" do
      before do
        make_invalid(@game)
        post :create, :game => { :name => @human.name }
      end
      it { response.should redirect_to(new_game_path) }
      it "sets the flash error message" do
        flash[:error].should =~ /can not create game/i
      end
    end

    context "with bad save on human" do
      before do
        make_invalid(@human, "boogey man")
        post :create, :game => { :name => @human.name }
      end
      it { response.should redirect_to(new_game_path) }
      it "flash message should include human error messages" do
        flash[:error].should =~ /can not create game/i
        flash[:error].should =~ /boogey man/i
      end
    end
  end
end
