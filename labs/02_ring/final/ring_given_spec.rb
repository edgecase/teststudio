require 'rspec/given'

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

  Given(:max_size) { 3 }
  Given(:original_elements) { [] }
  Given(:ring) {
    Ring.new(max_size).tap do |r|
      original_elements.each do |item| r.insert(item) end
    end
  }

  context "when being created with no parameters" do
    Given(:ring) { Ring.new }
    Then { ring.should be_empty }
    Then { ring.max_size.should == 1 }
    Then { ring.length.should == 0 }
    Then { ring.elements.should == [] }
  end

  context "when created with a zero max size" do
    Then {
      lambda { Ring.new(0) }.
        should raise_error(ArgumentError)
    }
  end

  context "when setup with an initial max size" do
    context "when being created" do
      Then { ring.max_size.should == max_size }
      Then { ring.length.should be_zero }
      Then { ring.should be_empty }
      Then { ring.elements.should == [] }
    end

    context "when an item is added" do
      When { ring.insert(:oldest) }

      Then { ring.length.should == 1 }
      Then { ring.max_size.should == max_size }
      Then { ring.elements.should == [:oldest] }
    end
  end

  context "when removing an item" do
    Given(:original_elements) { [:oldest, :newest] }

    When(:result) { ring.remove }

    Then { ring.length.should == 1 }
    Then { result.should == :oldest }

    context "when the 2nd item is removed" do
      When(:second_result) { ring.remove }
      Then { second_result.should == :newest }
    end
  end

  context "when empty" do
    When(:result) { ring.remove }

    Then { ring.should be_empty }
    Then { result.should be_nil }
    Then { ring.max_size.should == max_size }
    Then { ring.elements.should == [] }
  end

  context "when full" do
    Given(:original_elements) { [:oldest, :next_oldest, :newest] }

    Then { ring.should be_full }

    context "and adding an item" do
      When { ring.insert(:inserted_element) }

      Then { ring.max_size.should == max_size }
      Then { ring.should be_full }

      context "and then removing an item" do
        When(:result) { ring.remove }
        Then { result.should == :next_oldest }
      end
    end
  end

  context "when calling elements" do
    Given(:original_elements) { [:oldest, :newest] }

    Then { ring.elements.should be_kind_of(Array) }
  end
end
