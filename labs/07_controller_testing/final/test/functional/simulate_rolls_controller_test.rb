require 'test_helper'

class SimulateRollsControllerTest < ActionController::TestCase
  context 'The index action' do
    context 'when not simulating' do
      should 'render no simulation' do
        flexmock(@controller).should_receive(:render).once.with(:text => "SIMULATION IS OFF")
        flexmock(@controller).should_receive(:render)
        get :index
      end
    end
    context 'when simulating' do
      setup do
        session[:simulation] = [[1]]
      end
      should 'render simulation' do
        flexmock(@controller).should_receive(:render).once.with(:text => "SIMULATING: [[1]]")
        flexmock(@controller).should_receive(:render)
        get :index
      end
    end
  end

  context 'The clear action' do
    setup do
      get :clear
    end
    should 'clear the simulated data in the session' do
      assert_equal nil, session[:simulation]
    end
  end

  context 'The simulate action' do
    setup do
      get :simulate, :faces => "1-2-3-4-5"
    end
    should 'set the simulated data in the session' do
      assert_equal [[1, 2, 3, 4, 5]], session[:simulation]
    end
    
    context 'with multiple calls' do
      setup do
        get :simulate, :faces => "1-1-1"
      end
      
      should 'add to the simulated data in the session' do
        assert_equal [[1, 2, 3, 4, 5], [1, 1, 1]], session[:simulation]
      end
    end
  end
end
