require 'spec_helper'

describe Player do
  it "has a valid factory" do
    Factory.build(:player).should be_valid
  end

  let(:player) { Factory.build(:player) }

  it "provides a roller" do
    player.roller.should be_a Roller
  end

  context "with explicit roller" do
    before { player.roller = :fake_roller }
    it "uses the provided roller" do
      player.roller.should == :fake_roller
    end
  end

  context 'with muliple turns' do
    before do
      (1..4).each do |n|
        @last_turn = Factory.build(:turn)
        player.turns << @last_turn
      end
    end

    it "knows its last turn" do
      player.turns.last.should == @last_turn
    end
  end
end
