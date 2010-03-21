require 'rubygems'
require 'spec'

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

describe Ring, "when being created with no parameters" do

  before(:each) do
    @ring = Ring.new
  end

  it "should say it's empty" do
    @ring.should be_empty
  end

  it "should have a max size of one" do
    @ring.max_size.should == 1
  end

  it "should have a length of zero" do
    @ring.length.should == 0
  end

end

describe "when created with a zero max size" do
  it "should throw an execption" do
    lambda {
      Ring.new(0)
    }.should raise_error(ArgumentError)
  end
end

describe "when setup with an initial max size" do
  
  before(:each) do
    @max_size = 3
    @ring = Ring.new(@max_size)
  end
    
  describe "when being created" do
    it "should report it's max size as the initial size" do
      @ring.max_size.should == @max_size
    end

    it "should report it's length as zero" do
      @ring.length.should be_zero
    end

    it "should report as empty" do
      @ring.should be_empty
    end
  end
  
  describe Ring, "when an item is added" do

    before(:each) do
      @ring.insert(:one)
    end

    it "should report it's length as one" do
      @ring.length.should == 1
    end

    it "should report it's max size as the initial size" do
      @ring.max_size.should == @max_size
    end
  end
  
end

describe Ring, "when removing an item" do

  before(:each) do
    @ring = Ring.new(3)
    @ring.insert(:one)
    @ring.insert(:two)
  end

  it "should decrement it's length by one" do
    @ring.remove
    @ring.length.should == 1
  end

  it "should remove the item in FIFO order" do
    @ring.remove.should == :one
    @ring.remove.should == :two
  end

end

describe Ring, "when empty" do

  before(:each) do
    @max_size = 3
    @ring = Ring.new(@max_size)
  end

  it "should say it's empty" do
    @ring.should be_empty
  end

  it "should return nil when removing items" do
    @ring.remove.should be_nil
  end

  it "should not change max size when removing items" do
    @ring.remove
    @ring.max_size == 0
    @ring.should be_empty
  end
end

describe Ring, "when full" do

  before(:each) do
    @max_size = 3
    @ring = Ring.new(@max_size)
    @ring.insert(:oldest)
    @ring.insert(:next_oldest)
    @ring.insert(:last)
  end

  it "should say it's full" do
    @ring.should be_full
  end

  it "should not grow when adding new items" do
    @ring.insert(:newest)
    @ring.max_size.should == 3
  end

  it "should drop the oldest item when adding new items" do
    @ring.insert(:newest)
    @ring.remove.should == :next_oldest
  end

end

describe Ring, "when calling elements" do

  before(:each) do
    @max_size = 3
    @ring = Ring.new(@max_size)
    @ring.insert(:one)
    @ring.insert(:two)
  end

  it "should return all of it's elements" do
    @ring.elements.should == [:one, :two]
  end

  it "should return elements as an array" do
    @ring.elements.should be_kind_of(Array)
  end

end
