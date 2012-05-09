require 'spec_helper'

describe "AddGames" do
  describe "GET /games/new" do
    it "displays a form" do
      visit new_game_path
      response.status.should be(200)
    end
  end
end
