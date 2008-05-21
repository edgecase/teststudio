require File.dirname(__FILE__) + '/../test_helper'

class ReservationViewTest < Test::Rails::ViewTestCase

  fixtures :reservations, :room_types

  def test_new                                                                                                                                    
    assigns[:reservation] = reservation(
      Date.parse("Sept 5, 2007"), 
      Date.parse("Sept 24, 2007") )
    assigns[:availability] = [
      [RoomType.new(:name => "King"), 99.00]
    ]

    render :action => 'new'

    assert_form '/reservations' do
      assert_submit 'Check Rate'
    end
  end
end
