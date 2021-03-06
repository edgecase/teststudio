require 'spec_helper'

describe Roll do
  it "has a valid factory" do
    Factory(:roll).should be_valid
  end

  let(:roll) {
    Factory(:roll, :faces => [])
  }

  def set_faces(*face_values)
    roll.faces = face_values.map { |v| Factory(:face, :value => v) }
    roll
  end

  describe "accessors" do
    context "with faces" do
      subject { set_faces(2, 3, 5, 5) }

      its(:face_values) { should == [2, 3, 5, 5] }
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

  describe "#dice_to_roll" do
    let(:roll) { Roll.new_from_roller(roller, 200) }
    subject { roll }

    context "no scoring dice" do
      let(:roller) { roller_that_rolled(5, [2,2,3,3,4]) }
      its(:dice_to_roll) { should == 5 }
    end

    context "some scoring dice" do
      let(:roller) { roller_that_rolled(5, [1,2,3,4,5]) }
      its(:dice_to_roll) { should == 3 }
    end

    context "all scoring dice" do
      let(:roller) { roller_that_rolled(5, [1,1,1,1,1]) }
      its(:dice_to_roll) { should == 5 }
    end
  end

  describe "Roll.new_from_roller" do
    let(:roller) { roller_that_rolled(5, [1,2,3,4,5]) }
    let(:roll) { Roll.new_from_roller(roller, 200) }

    subject { roll }

    its(:score) { should == roller.points }
    its(:unused) { should == roller.unused }
    it "should match the faces" do
      roll.faces.map(&:value).should == roller.faces
    end
  end
end
