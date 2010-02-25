require 'test_helper'

class FaceTest < ActiveSupport::TestCase
  
  test "should ensure value is a number" do
    @model = Factory.build(:face, :value => "NAN")
    
    assert_numericality_of :value
  end

  test "should ensure position is a number" do
    @model = Factory.build(:face, :position => "NAN")
    
    assert_numericality_of :position
  end
  
  test "should ensure value is between 1 and 6" do
    @model = Factory.build(:face, :value => 7)
    
    assert_inclusion_in :value
  end

  
end
