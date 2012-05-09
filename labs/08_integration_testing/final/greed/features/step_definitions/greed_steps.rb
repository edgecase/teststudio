Given /^I am ready to add a game$/ do
  visit '/games/new'
end

Given /^there is "([^"]*)" member with rank (\d+)$/ do |name, rank| # "
  Member.create!(name: name, email: "x@x.com", rank: rank)
end

When /^I select "([^"]*)" as the winner$/ do |winner_name| # "
  select winner_name, from: 'winner_id'
end

When /^I select "([^"]*)" as the loser$/ do |loser_name| # "
  select loser_name, from: 'loser_id'
end

When /^I record the game$/ do
  click_button 'Record Game'
end

Then /^I see "([^"]*)" with a (\d+) rank$/ do |member_name, rank| # "
  member = Member.find_by_name(member_name)
  within(".member_#{member.id}") do
    page.should have_content(member_name)
    page.should have_content(rank)
  end
end
