require 'spec_helper'

feature "Add a Member" do
  background do
    visit root_path
  end

  scenario "Creating a new Member" do
    click_link "New Member"

    fill_in "member[name]", with: "Eli"
    fill_in "member[email]", with: "eli@shipshe.com"
    fill_in "member[rank]", with: "1000"
    click_button "Create Member"

    response.should contain(/member *eli/i)
    response.should contain(/email: *eli@shipshe.com/i)
    response.should contain(/rank: *1000\b/i)
  end
end
