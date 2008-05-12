require 'test/unit'
require 'rubygems'
gem 'flexmock'
require 'flexmock/test_unit'

class MockTest < Test::Unit::TestCase
  def test_returns_expected
    mock = flexmock('a mock')
    mock.should_receive(:calc).once.and_return(5)
    mock.should_receive(:calc).once.and_return(6)

    assert_equal 5, mock.calc
    assert_equal 6, mock.calc
  end

  # fill in more mocks here.
  
end
