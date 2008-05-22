
# A Ring data structure is similar to a fixed sized FIFO queue.
# Elements inserted into the ring can be removed in FIFO order.  If
# the ring is full, the next insertion will drop the oldest element of
# the ring.
#
class Ring 
  attr_reader :size, :elements

  def initialize(size=1)
    # Implement this method
  end

  def empty?
    # Implement this method
  end

  def length
    # Implement this method
  end

  def insert(item)
    # Implement this method
  end

  def remove
    # Implement this method
  end

  def full?
    # Implement this method
  end
end

describe Ring, "when being created with no parameters" do

  before(:each) do
    @ring = Ring.new
  end

  it "should say it's empty" do
    @ring.should be_empty
  end

  it "should have a size of one" do
    @ring.size.should == 1
  end

  it "should have a length of zero" do
    @ring.length.should == 0
  end

end

describe "when setup with an initial size", :shared => true do
  before(:each) do
    @max_size = 3
    @ring = Ring.new(@max_size)
  end
end

describe "when being created with an initial size" do

  it_should_behave_like "when setup with an initial size"

  it "should report it's size as the initial size"
  it "should report it's length as zero"
  it "should say that it is empty"
end

describe Ring, "when an item is added" do

  it_should_behave_like "when setup with an initial size"

  before(:each) do
    @ring.insert(:one)
  end

  it "should report it's length as one"
  it "should report it's size as the initial size"
end

describe Ring, "when removing an item" do

  before(:each) do
    @ring = Ring.new(3)
    @ring.insert(:one)
    @ring.insert(:two)
  end

  it "should decrement it's length by one"
  it "should remove the item in FIFO order"
end

describe Ring, "when empty" do

  before(:each) do
    @max_size = 3
    @ring = Ring.new(@max_size)
  end

  it "should say it's empty"
  it "should return nil when removing items"
  it "should not change size when removing items"
end

describe Ring, "when full" do

  before(:each) do
    @max_size = 3
    @ring = Ring.new(@max_size)
    @ring.insert(:oldest)
    @ring.insert(:next_oldest)
    @ring.insert(:last)
  end

  it "should say it's full"
  it "should not grow when adding new items"
  it "should drop the oldest item when adding new items"
end

describe Ring, "when calling elements" do

  before(:each) do
    # implenment this
  end

  it "should return all of it's elements"
  it "should return elements as an array"
end
