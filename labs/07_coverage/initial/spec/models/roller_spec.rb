require 'spec_helper'

describe Roller do
  context "with live data" do
    let(:roll_sample_size) { 1200 }
    let(:expected_bin_size) { (5 * roll_sample_size) / 6.0 }
    let(:roller) { Roller.new }

    context "with 2 dice" do
      subject { roller.roll(2); roller }
      its(:faces) { should have(2).faces }
    end

    context "with 6 dice" do
      subject { roller.roll(6); roller }
      its(:faces) { should have(6).faces }
    end

    context "counted faces" do
      subject { collect_face_counts(roll_sample_size) }
      its(:keys) { should be_all { |n| (1..6).include?(n) } }
      its(:values) { should be_all { |c| in_percentage?(c, expected_bin_size, 10) }}
    end

    private

    def in_percentage?(amount, total, percent)
      delta = total * percent / 100.0
      amount >= (total - delta) && amount <= (total + delta)
    end

    def collect_face_counts(rolls)
      result = Hash.new { |h, k| h[k] = 0 }
      rolls.times do
        roller.roll(5)
        roller.faces.each do |face|
          result[face] += 1
        end
      end
      result
    end
  end

  context 'with simulated data' do
    let(:roller) { Roller.new(simulated_data) }

    context 'with a scoring roll' do
      let(:simulated_data) { SimulatedData.new([[1, 5, 2, 3, 2]]) }

      it 'calculates the correct scores' do
        roller.roll(5)
        roller.points.should == 150
        roller.unused.should == 3
        roller.new_score(50).should == 200
        roller.should_not be_bust
      end
    end

    context 'with a non-scoring roll' do
      let(:simulated_data) { SimulatedData.new([[2, 3, 4, 6, 6]]) }

      it 'calculates the correct scores' do
        roller.roll(5)
        roller.points.should == 0
        roller.unused.should == 5
        roller.new_score(50).should == 0
        roller.should be_bust
      end
    end
  end
end
