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
  let(:max_size) { 3 }
  let(:ring) { Ring.new(max_size) }

  subject { ring }

  context "when being created with no parameters" do
    let(:ring) { Ring.new }

    it { should be_empty }
    its(:max_size) { should == 1 }
    its(:length) { should be_zero }
  end

  context "when created with a zero max size" do
    let(:max_size) { 0 }

    it "should throw an execption" do
      lambda { ring }.should raise_error(ArgumentError)
    end
  end

  context "when setup with an initial max size" do
    context "when being created" do
      its(:max_size) { should == max_size }
      its(:length) { should == 0 }
      it { should be_empty }
    end

    context "when an item is added" do
      before { ring.insert(:one) }

      its(:length) { should == 1 }
      its(:max_size) { should == max_size }
      it { should_not be_empty }
    end
  end

  context "when removing" do
    before do
      ring.insert(:one)
      ring.insert(:two)
    end

    context "a single item" do
      before { @removed_item = ring.remove }
      its(:length) { should == 1 }
    end

    context "several items" do
      before do
        @first_removed = ring.remove
        @second_removed = ring.remove
      end
      it "removes items in fifo order" do
        @first_removed == :one
        @second_removed == :two
      end
    end
  end

  context "when empty" do
    it { should be_empty }

    context "when removing items" do
      let(:removed_item) { ring.remove }

      it { removed_item.should be_nil }

      its(:max_size) { should == 3 }
    end
  end

  context "when full" do
    before do
      ring.insert(:oldest)
      ring.insert(:next_oldest)
      ring.insert(:last)
    end

    it { should be_full }

    context "when adding items" do
      before { ring.insert(:newest) }

      its(:max_size) { should == 3 }

      context "and then removing an item" do
        let(:removed_item) { ring.remove }
        it { removed_item.should == :next_oldest }
      end
    end
  end

  context "when calling elements" do
    subject { a_ring_with_two_elements }

    its(:elements) { should == [:one, :two] }
    its(:elements) { should be_an(Array) }
  end

  private

  def a_ring_with_two_elements
    ring.insert(:one)
    ring.insert(:two)
    ring
  end
end
