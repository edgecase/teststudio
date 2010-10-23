require 'rubygems'

# A Ring data structure is similar to a fixed sized FIFO queue.
# Elements inserted into the ring can be removed in FIFO order.  If
# the ring is full, the next insertion will drop the oldest element of
# the ring.
#
class Ring
  attr_reader :max_size, :elements

  def initialize(max_size=1)
    fail ArgumentError, "Ring max size cannot be zero" if max_size == 0
    @max_size = max_size
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
    length == max_size
  end
end

describe Ring do
  context "when being created with no parameters" do
    before do
      @ring = Ring.new
    end

    it "is empty" do
      @ring.should be_empty
    end

    it "has a max size of one" do
      @ring.max_size.should == 1
    end

    it "has a length of zero" do
      @ring.length.should == 0
    end
  end

  context "when created with a zero max size" do
    it "throws an execption" do
      lambda {
        Ring.new(0)
      }.should raise_error(ArgumentError)
    end
  end

  context "when setup with an initial max size" do
    before do
      @max_size = 3
      @ring = Ring.new(@max_size)
    end

    describe "when being created" do
      it "has max size as the initial size" do
        @ring.max_size.should == @max_size
      end

      it "has a length of zero" do
        @ring.length.should be_zero
      end

      it "is empty" do
        @ring.should be_empty
      end
    end

    context "when an item is added" do
      before do
        @ring.insert(:one)
      end

      it "has a length of one" do
        @ring.length.should == 1
      end

      it "has the max size as the initial size" do
        @ring.max_size.should == @max_size
      end
    end
  end

  context "when removing an item" do
    before do
      @ring = Ring.new(3)
      @ring.insert(:one)
      @ring.insert(:two)
    end

    it "decrements it's length by one" do
      @ring.remove
      @ring.length.should == 1
    end

    it "removes the item in FIFO order" do
      @ring.remove.should == :one
      @ring.remove.should == :two
    end
  end

  context "when empty" do
    before do
      @max_size = 3
      @ring = Ring.new(@max_size)
    end

    it "is empty" do
      @ring.should be_empty
    end

    it "returns nil when removing items" do
      @ring.remove.should be_nil
    end

    it "does not change max size when removing items" do
      @ring.remove
      @ring.max_size == 0
      @ring.should be_empty
    end
  end

  context "when full" do
    before do
      @max_size = 3
      @ring = Ring.new(@max_size)
      @ring.insert(:oldest)
      @ring.insert(:next_oldest)
      @ring.insert(:last)
    end

    it "is full" do
      @ring.should be_full
    end

    it "does not grow when adding new items" do
      @ring.insert(:newest)
      @ring.max_size.should == 3
    end

    it "drops the oldest item when adding new items" do
      @ring.insert(:newest)
      @ring.remove.should == :next_oldest
    end
  end

  context "when calling elements" do
    before do
      @max_size = 3
      @ring = Ring.new(@max_size)
      @ring.insert(:one)
      @ring.insert(:two)
    end

    it "returns all of it's elements" do
      @ring.elements.should == [:one, :two]
    end

    it "returns elements as an array" do
      @ring.elements.should be_kind_of(Array)
    end
  end
end
