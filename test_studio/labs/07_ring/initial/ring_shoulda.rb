require 'test/unit'
require 'shoulda'

# A Ring data structure is similar to a fixed sized FIFO queue.
# Elements inserted into the ring can be removed in FIFO order.  If
# the ring is full, the next insertion will drop the oldest element of
# the ring.
#
class Ring 
  attr_reader :size, :elements

  def initialize(size=1)
    # Please implement
  end

  def empty?
    # Please implement
  end

  def length
    # Please implement
  end

  def insert(item)
    # Please implement
  end

  def remove
    # Please implement
  end

  def full?
    # Please implement
  end
end

class RingTest < Test::Unit::TestCase
  context "A Ring created with no parameters" do

    setup do
      @ring = Ring.new
    end

    should "say it's empty" do
      assert @ring.empty?
    end
    
    should "have a size of one" do
      assert_equal 1, @ring.size
    end
    
    should "have a length of zero" do
      assert_equal 0, @ring.length
    end
  end
  
  context "A Ring when created with a zero size" do
    should "throw an execption" do
      ex = assert_raise(ArgumentError) do
        Ring.new(0)
      end
      assert_match(/size/, ex.message)
      assert_match(/zero/, ex.message)
    end
  end

  def setup_ring_with_fixed_size
    @max_size = 3
    @ring = Ring.new(@max_size)
  end

  context "A Ring when being created with an initial size" do

    setup do
      setup_ring_with_fixed_size
    end

    should "report it's size as the initial size" do
      # Please implement
    end

    should "report it's length as zero" do
      # Please implement
    end

    should "report as empty" do
      # Please implement
    end
  end

  context "A Ring when an item is added" do

    setup do
      # Please implement
    end
    
    should "report it's length as one" do
      # Please implement
    end

    should "report it's size as the initial size" do
      # Please implement
    end
  end

  context "A Ring when removing an item" do
    setup do
      # Please implement
    end
    
    should "decrement it's length by one" do
      # Please implement
    end
    
    should "remove the oldest item" do
      # Please implement
    end
  end

  context "A Ring when empty" do

    setup do
      # Please implement
    end

    should "say it's empty" do
      # Please implement
    end

    should "return nil when removing items" do
      # Please implement
    end

    should "not change length when removing items" do
      # Please implement
    end
  end

  context "A Ring when full" do

    setup do
      # Please implement
    end

    should "say it's full" do
      # Please implement
    end

    should "not grow when adding new items" do
      # Please implement
    end

    should "drop the oldest item when adding new items" do
      # Please implement
    end
  end

  context "A Ring when calling elements" do
    setup do
      # Please implement
    end

    should "return all of it's elements" do
      # Please implement
    end

    should "return elements as an array" do
      # Please implement
    end
  end
end
