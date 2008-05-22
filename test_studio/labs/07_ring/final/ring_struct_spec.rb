
class Ring 
  attr_reader :size
  def initialize(size=0)
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
    @elements << item
  end
  def remove
  end
  def full?
  end
end

describe Ring, "when being created with no parameters" do

  before(:each) do
    @ring = Ring.new
  end

  it "should say it's empty" do
    @ring.should be_empty
  end

  it "should have a size of zero" do
    @ring.size.should == 0
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

  it "should report it's size as the initial size" do
    @ring.size.should == @max_size
  end

  it "should report it's length as zero" do
    @ring.length.should be_zero
  end

  it "should report as empty" do
    @ring.should be_empty
  end
end

describe Ring, "when an items is added" do

  it_should_behave_like "when setup with an initial size"

  before(:each) do
    @ring.insert(:one)
  end

  it "should report it's length as one" do
    @ring.length.should == 1
  end

  it "should report it's size as the initial size" do
    @ring.size.should == @max_size
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
    @ring.length.should be_equal(1)
    @ring.length.should == 1
  end

  it "should remove the item in FIFO order"

end

describe Ring, "when full" do

  it "should say it's full"
  it "should drop off oldest item when a new item added"

end

describe Ring, "when calling elements" do

  it "should return all of it's elements"
  it "should return elements as an array"

end
