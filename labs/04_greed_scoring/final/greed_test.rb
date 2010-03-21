require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'greed'

class GreedTest < Test::Unit::TestCase
  context 'The score of a roll of no values' do
    setup { @roll = [] }
    should 'be zero' do
      assert_equal 0, score(@roll)
    end
  end

  context 'The score of all non-scoring values' do
    setup { @roll = [2, 3, 4, 6] }
    should 'be zero' do
      assert_equal 0, score(@roll)
    end
  end

  context 'The score of a single 5' do
    setup { @roll = [5] }
    should 'be 50' do
      assert_equal 50, score(@roll)
    end
  end

  context 'The score of mixed 5s and 1s' do
    setup { @roll = [1,5,1] }
    should 'be 250' do
      assert_equal 250, score(@roll)
    end
  end

  context 'The score of a triple number' do
    setup { @roll = [2, 2, 2] }
    should 'be 200' do
      assert_equal 200, score(@roll)
    end
  end

  context 'The score of triple ones' do
    setup { @roll = [ 1, 1, 1 ] }
    should 'be 1000' do
      assert_equal 1000, score([1,1,1])
    end
  end

  context 'The score of mixed numbers' do
    setup { @roll = [ 4, 5, 3, 4, 4 ] }
    should 'be 450' do
      assert_equal 450, score(@roll)
    end
  end

end
