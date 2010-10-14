require 'spec_helper'

describe GamesController do
  describe "GET new" do
    it "renders the new view" do
      get :new
      response.should render_template("new")
    end
  end
end
