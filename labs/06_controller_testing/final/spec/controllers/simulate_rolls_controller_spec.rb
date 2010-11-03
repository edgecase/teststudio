require 'spec_helper'

describe SimulateRollsController do
  describe "GET index" do
    context "with no simulated data" do
      before { get :index }
      it "says the simulation is off" do
        response.body.should == "SIMULATION IS OFF"
      end
    end

    context "with simulated data" do
      before do
        session[:simulation] = [[1,2,3,4,5]]
        get :index
      end

      it "says the simulation is off" do
        response.body.should == "SIMULATING: [[1, 2, 3, 4, 5]]"
      end
    end
  end

  describe "GET clear" do
    before { get :clear }
    it { session[:simulation].should be_nil }
  end

  describe "GET simulate" do
    before do
      session[:simulation] = [[1,2,3,4,5]]
      get :simulate, :faces => "2,3,2,3,2"
    end
    it { session[:simulation].should == [[1,2,3,4,5], [2,3,2,3,2]] }
  end
end
