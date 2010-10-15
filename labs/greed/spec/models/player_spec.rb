require 'spec_helper'

describe Player do
  it "has a valid factory" do
    Factory.build(:player).should be_valid
  end

  let(:player) { Factory.build(:player) }
  subject { player }

  it "provides a roller" do
    player.roller.should be_a Roller
  end

  describe "#last_action" do
    context "with no turns or rolls" do
      its(:last_action) { should be_nil }
    end

    context "with a turn and some rolls" do
      before do
        player.turns << Factory.build(:turn, :rolls => [Roll.new(:action => :bust)])
        player.turns << Factory.build(:turn, :rolls => [Roll.new(:action => :hold)])
      end
      its(:last_action) { should be :hold }
    end
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
