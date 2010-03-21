
# A Ring data structure is similar to a fixed sized FIFO queue.
# Elements inserted into the ring can be removed in FIFO order.  If
# the ring is full, the next insertion will drop the oldest element of
# the ring.
#
class Ring 
  attr_reader :max_size, :elements

  def initialize(max_size=1)
    # Implement this method
  end

  def empty?
    # Implement this method
  end

  def full?
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
end

# This describ block is already implemented for demo purposes.
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

# Another example description on how to detect execeptions.
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
    it "should report it's max_size as the initial size"
    it "should report it's length as zero"
    it "should say that it is empty"
  end

  describe Ring, "when an item is added" do

    before(:each) do
      @ring.insert(:one)
    end

    it "should report it's length as one"
    it "should report it's max size as the initial max size"
  end
end

describe Ring, "when removing an item" do

  before(:each) do
    # implement this
  end

  it "should decrement it's length by one"
  it "should remove the item in FIFO order"
end

describe Ring, "when empty" do

  before(:each) do
    # implement this
  end

  it "should say it's empty"
  it "should return nil when removing items"
  it "should not change max size when removing items"
end

describe Ring, "when full" do

  before(:each) do
    # implement this
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
