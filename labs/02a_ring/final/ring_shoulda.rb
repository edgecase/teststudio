require 'rubygems'
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
    fail ArgumentError, "Ring size cannot be zero" if size == 0
    @size = size
    @elements = []
  end

  def empty?
    length == 0
  end

  def length
    @elements.size
  end

  def insert(item)
    remove if full?
    @elements << item
  end

  def remove
    @elements.shift
  end

  def full?
    length == size
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
      assert_equal @max_size, @ring.size
    end

    should "report it's length as zero" do
      assert_equal 0, @ring.length
    end

    should "report as empty" do
      assert @ring.empty?
    end
  end

  context "A Ring when an item is added" do

    setup do
      setup_ring_with_fixed_size
      @ring.insert(:one)
    end
    
    should "report it's length as one" do
      assert_equal 1, @ring.length
    end

    should "report it's size as the initial size" do
      assert_equal @max_size, @ring.size
    end
  end

  context "A Ring when removing an item" do
    setup do
      setup_ring_with_fixed_size
      @ring.insert(:one)
      @ring.insert(:two)
    end
    
    should "decrement it's length by one" do
      @ring.remove
      assert_equal 1, @ring.length
    end
    
    should "remove the oldest item" do
      assert_equal :one, @ring.remove
      assert_equal :two, @ring.remove
    end
  end

  context "A Ring when empty" do

    setup do
      setup_ring_with_fixed_size
    end

    should "say it's empty" do
      assert @ring.empty?
    end

    should "return nil when removing items" do
      assert_nil @ring.remove
    end

    should "not change length when removing items" do
      @ring.remove
      assert_equal 0, @ring.length
      assert @ring.empty?
    end
  end

  context "A Ring when full" do

    setup do
      setup_ring_with_fixed_size
      @ring.insert(:oldest)
      @ring.insert(:next_oldest)
      @ring.insert(:last)
    end

    should "say it's full" do
      assert @ring.full?
    end

    should "not grow when adding new items" do
      @ring.insert(:newest)
      assert_equal 3, @ring.length
    end

    should "drop the oldest item when adding new items" do
      @ring.insert(:newest)
      assert_equal :next_oldest, @ring.remove
    end
  end

  context "A Ring when calling elements" do
    setup do
      setup_ring_with_fixed_size
      @ring.insert(:one)
      @ring.insert(:two)
    end

    should "return all of it's elements" do
      assert_equal [:one, :two], @ring.elements
    end

    should "return elements as an array" do
      assert @ring.elements.kind_of?(Array)
    end
  end
end
