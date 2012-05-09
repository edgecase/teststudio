require 'spec_helper'

describe "Add a Member" do
  context "from the root page" do
    When { visit root_path }
    Then { response.status.should be(200) }

    context "going to the new members page" do
      When { click_link "New Member" }
      Then { response.should contain(/New Member/) }

      context "and filling in the new member info" do
        When {
          fill_in "member[name]", with: "Eli"
          fill_in "member[email]", with: "eli@shipshe.com"
          fill_in "member[rank]", with: "1000"
          click_button "Create Member"
        }
        Then {
          response.should contain(/member *eli/i)
          response.should contain(/email: *eli@shipshe.com/i)
          response.should contain(/rank: *1000\b/i)
        }
      end
    end
  end
end
