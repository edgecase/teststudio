require 'spec_helper'

describe Face do
  it "has a valid factory" do
    Factory(:face).should be_valid
  end

  subject { Face.new(:value => 3) }
  its(:value) { should == 3 }
end
