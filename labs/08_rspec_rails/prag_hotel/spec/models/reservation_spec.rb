require File.dirname(__FILE__) + '/../spec_helper'

describe Reservation, "- when being created" do

  it "should require a name" do
    ops_without_name = Reservation.valid_options
    ops_without_name.delete(:name)
    reservation = Reservation.new(ops_without_name)

    reservation.should_not be_valid
    reservation.should have(1).errors_on(:name)
    reservation.errors.on(:name).should == "can't be blank"
  end
end
