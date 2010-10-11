require 'spec_helper'

describe Roll do
  it "has a valid factory" do
    Factory.build(:roll).should be_valid
  end

  let(:roll) {
    Factory.build(:roll,
      :accumulated_score => 300,
      :faces => [])
  }

  context "with faces" do
    subject {
      roll.faces = [
        Factory.build(:face, :value => 2),
        Factory.build(:face, :value => 3),
        Factory.build(:face, :value => 5),
        Factory.build(:face, :value => 5),
      ]
      roll
    }

    its(:face_values) { should == [2, 3, 5, 5] }
    its(:accumulated_score) { should == 300 }
    its(:points) { should == 100 }
    its(:unused) { should == 2 }
    its(:action) { should be_nil }

    context "when an action is added" do
      before { subject.action = "roll" }
      its(:action) { should == :roll }
    end

    context 'when it is busted' do
      before{ subject.action = :bust }
      its(:accumulated_score) { should == 0 }
    end
  end

  context 'when saved' do
    subject { roll }

    before do
      subject.action = :hold
      subject.save!
      subject.reload
    end

    its(:action) { should == :hold }
  end
end
