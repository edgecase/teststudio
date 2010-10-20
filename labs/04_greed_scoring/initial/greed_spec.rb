require 'greed'

describe "#score" do
  let(:roll) { [] }
  subject { score(roll) }

  context "with no values" do
    it { should == 0 }
  end

  context "with all non-scoring values" do
    let(:roll) { [2,3,4,6] }
    it { should == 0 }
  end

  context 'The score of a single 5' do
    # WRITE THE LETs and ITs HERE
  end

  context 'The score of a single 1' do
    # WRITE THE LETs and ITs HERE
  end

  context 'The score of mixed 5s and 1s' do
    # WRITE THE LETs and ITs HERE
  end

  context 'The score of a triple number' do
    # WRITE THE LETs and ITs HERE
  end

  context 'The score of triple ones' do
    # WRITE THE LETs and ITs HERE
  end

  context 'The score of mixed numbers' do
    # WRITE THE LETs and ITs HERE
  end
end
