require File.dirname(__FILE__) + '/../spec_helper'

describe ReservationsController, "when calling index" do

  it "should call find :all on reservation" do
    flexmock(Reservation).should_receive(:find).with(:all).once

    get :index
  end

  it "should return successfully" do
    get :index

    response.should be_success
  end

  it "should render index.html.erb" do
    get :index

    response.should render_template('reservations/index')
  end

end
