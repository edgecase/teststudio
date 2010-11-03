module GreedContructionUtilities

  # Return a roller that has just rolled the indicated number of dice
  # and results in the given faces.
  def roller_that_rolled(number_of_dice, faces)
    result = Roller.new
    flexmock(result).should_receive(:random_faces).
      and_return(faces)
    result.roll(number_of_dice)
    result
  end

  RSpec.configure {|c| c.include self}
end
