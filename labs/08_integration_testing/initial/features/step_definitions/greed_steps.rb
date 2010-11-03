Then /^I am asked to choose players$/ do
  page.should  have_content("Select Your Opponent")
end

Given /^a fresh start$/ do
  visit "/simulate/clear"
end

Given /^the dice will roll ([1-6,]+)$/ do |faces|
  f = faces.split(",").map { |n| n.to_i }.join("-")
  visit "/simulate/#{f}"
end

Given /^I take a turn$/ do
  click_link("Start Your Turn")
end

Given /^I start a game$/ do
  $roller = nil
  visit path_to("the homepage")
  fill_in("game_name", :with => "John")
  click_button("Next")
  choose("ConservativeStrategy")
  click_button("Play")
end

Given /^I look at the total score for (\w+)$/ do |player|
  doc = Nokogiri::HTML(page.body)
  n = doc.css("span.score")
  @saved_total_points = n.first.text
end

When /^I refresh the screen$/ do
  visit current_path
end

Then /^the total score for Connie is unchanged$/ do
  doc = Nokogiri::HTML(page.body)
  n = doc.css("span.score")
  n.first.text.should == @saved_total_points
end

Then /^the turn score so far is (\d+)$/ do |score|
  page.should have_content("so far: #{score}")
end

When /^I choose to hold$/ do
  click_link "Hold"
end

When /^I continue$/ do
  click_link "Continue"
end

Then /^(\w+)'s game score is (\d+)$/ do |player, score| # '
  page.should have_content("#{player} #{score}")
end

Then /^it is my turn$/ do
  page.should have_content("Your Turn")
end

Then /^it is (\w+)'s turn$/ do |player| # '
  page.should have_content("#{player}'s Turn")
end

Then /^(\w+) go(es)? bust$/ do |player, _|
  player = "John" if player == "I"
  within("p.action") do
    page.should have_content("#{player} went bust")
  end
end

When /^I choose to roll again$/ do
  click_link "Roll again"
end

Then /^(\d+) dice are displayed$/ do |dice_count|
  ul = css("ul.dice")
  li = ul.last.css("li.die")

  li.size.should == dice_count.to_i
end

Then /^(\w+) wins the game$/ do |player|
  page.should have_content "The Winner is #{player}"
end

# Helpers ------------------------------------------------------------

def css(pattern)
  doc = Nokogiri::HTML(page.body)
  doc.css(pattern)
end
