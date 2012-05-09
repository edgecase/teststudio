require 'spec_helper'

feature "Adding a new Game" do
  background do
    @winner = Member.create!(name: "A Winner", email: "winner@xyz.com", rank: 1000)
    @loser  = Member.create!(name: "A Loser", email: "loser@xyz.com", rank: 1000)
  end

  scenario "Signing in with correct credentials" do
    visit new_game_path
    select "A Winner", from: 'winner_id'
    select "A Loser", from: 'loser_id'
    click_button 'Record Game'

    within(".member_#{@winner.id}") do
      response.should contain(/A Winner/)
      response.should contain(/1016/)
    end
    within(".member_#{@loser.id}") do
      response.should contain(/A Loser/)
      response.should contain(/984/)
    end
  end
end