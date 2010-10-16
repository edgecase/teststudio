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

  def set_faces(*face_values)
    roll.faces = face_values.map { |v| Factory.build(:face, :value => v) }
    roll
  end

  describe "#action" do
    context "with no action" do
      before { subject.action_name = "" }
      its(:action) { should be_nil }
    end
    context "when an action is set as a string" do
      before { subject.action = "roll" }
      it "has a symbol for the action" do
        subject.action.should == :roll
      end
    end
  end

  context "with faces" do
    subject { set_faces(2, 3, 5, 5) }

    its(:face_values) { should == [2, 3, 5, 5] }
    its(:accumulated_score) { should == 300 }
    its(:points) { should == 100 }
    its(:unused) { should == 2 }
    its(:action) { should be_nil }
  end

  context "with alternate faces" do
    subject { set_faces(2, 2, 2, 5, 3) }
    its(:face_values) { should == [2,2,2,5,3] }
    its(:points) { should == 250 }
    its(:unused) { should == 1 }
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
