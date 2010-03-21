require 'test_helper'

class GameTest < ActiveSupport::TestCase
  context 'A game' do
    setup do
      @game = Factory.build :two_player_game
      @p1, @p2 = @game.players
    end
    
    context 'that is started' do
      setup do
        @game.start_game
      end

      should 'know the first player is the current player' do
        assert_equal @p1, @game.current_player
      end
    
      should 'calculate the next player' do
        assert_equal @p2, @game.next_player
      end
      
      context 'when setting the current player' do
        setup do
          @game.current_player = @game.next_player
        end
        should 'report the new current player' do
          assert_equal @p2, @game.current_player
        end
        should 'report the new next player' do
          assert_equal @p1, @game.next_player
        end
      end
    end
  end
  
  context 'A Game when saved' do
    setup do
      @faces = (1..5).map { |i| Face.new(:value => i) }
      @roll = Roll.new(:faces => @faces)
      @turn = Turn.new(:rolls => [@roll])
      @player = ComputerPlayer.new(:turns => [@turn])
      @game = Factory.build(:empty_game)
      @game.players = [@player]
      
      @game.save
    end
    
    should 'save all the elements' do
      assert ! @game.new_record?
      assert ! @player.new_record?
      assert ! @turn.new_record?
      assert ! @roll.new_record?
      @faces.each do |f|
        assert ! f.new_record?, "Face #{f.value} should not be new"
      end
    end
  end
end
