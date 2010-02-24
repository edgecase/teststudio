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
      # WRITE THE ASSERTIONS HERE
    end
  end

  context 'The score of a single 5' do
    # WRITE THE SETUP AND SHOULDs HERE
  end

  context 'The score of mixed 5s and 1s' do
    # WRITE THE SETUP AND SHOULDs HERE
  end

  context 'The score of a triple number' do
    # WRITE THE SETUP AND SHOULDs HERE
  end

  context 'The score of triple 1s' do
    # WRITE THE SETUP AND SHOULDs HERE
  end

  context 'The score of mixed numbers' do
    # WRITE THE SETUP AND SHOULDs HERE
  end
end
