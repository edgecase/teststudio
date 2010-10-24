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
    let(:roll) { [5] }
    it { should == 50 }
  end

  context 'The score of mixed 5s and 1s' do
    let(:roll) { [1,1,5] }
    it { should == 250 }
  end

  context 'The score of a triple number' do
    let(:roll) { [4,4,4] }
    it { should == 400 }
  end

  context 'The score of triple ones' do
    let(:roll) { [1,1,1] }
    it { should == 1000 }
  end

  context 'The score of mixed numbers' do
    let(:roll) { [2,5,3,3,3] }
    it { should == 350 }
  end
end
