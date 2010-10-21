require 'spec_helper'

describe HumanPlayer do
  describe "its validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:score) }
    it { should validate_numericality_of(:score) }
  end

  it "has a valid factory" do
    Factory.build(:human_player).should be_valid
  end

  let(:data) { [] }
  let(:roller) { Roller.new(SimulatedData.new(data)) }
  let(:player) {
    Factory.build(:human_player).tap { |p| p.roller = roller }
  }

  subject { player }

  its(:play_style) { should == :interactive }
  its(:description) { should == "Human" }

  describe "#undecided?" do
    let(:data) { [[1,2,3,4,5]] }

    context "no turns" do
      it { should_not be_undecided }
    end

    context "with undecided turn" do
      before do
        player.start_turn
        player.roll_dice
      end
      it { should be_undecided }
    end

    context "with a non-undecided turn" do
      before do
        player.start_turn
        player.roll_dice
        player.decides_to_roll_again
      end
      it { should_not be_undecided }
    end

  end

  context "when rolling dice" do
    context "on the first roll" do
      let(:data) { [[1,2,3,4,5]] }
      before do
        player.start_turn
        player.roll_dice
      end
      subject { last_roll }
      it { should have(5).faces }
    end

    context "on the second roll" do
      let(:data) { [[1,2,3,4,5], [1,2,3,4,5]] }
      before do
        player.start_turn
        player.roll_dice
        player.roll_dice
      end
      subject { last_roll }
      it { should have(3).faces }
    end

    context "on the roll after all dice have scored" do
      let(:data) { [[1,1,1,5,5], [1,2,3,4,5]] }
      before do
        player.start_turn
        player.roll_dice
        player.roll_dice
      end
      subject { last_roll }
      it { should have(5).faces }
    end

    def last_roll
      player.turns.last.rolls.last
    end
  end

  context "when taking turns" do
    context "after starting a turn" do
      let(:data) { [[1,2,3,4,5]] }
      before do
        player.start_turn
      end
      subject { player.turns.last }
      it { player.should have(1).turn }
    end

    context "after rolling the dice" do
      let(:data) { [[1,2,3,4,5]] }
      before do
        player.start_turn
        @action = player.roll_dice
      end

      subject { player.turns.last }
      its(:score) { should == 150 }
      it { @action.should == :ok }
    end

    context "after rolling the die and holding" do
      let(:data) { [[1,2,3,4,5], [2,2,3,3,4]] }
      before do
        player.start_turn
        player.roll_dice
        player.decides_to_hold
      end

      subject { player.turns.last }
      its(:score) { should == 150 }
    end

    context "after rolling the die, continuing, then going bust" do
      let(:data) { [[1,2,3,4,5], [2,2,3,3,4]] }
      before do
        player.start_turn
        player.roll_dice
        player.decides_to_roll_again
        @action = player.roll_dice
        player.goes_bust
      end

      subject { player.turns.last }
      it { should have(2).rolls }
      it { should_not be_undecided }
      its(:score) { should == 0 }
      it { @action.should == :bust }

      context "and then going bust" do
        before { player.goes_bust }
        it { should_not be_undecided }
        it "should record being bust" do
          subject.rolls.last.action.should be :bust
        end
      end
    end

    context "after rolling, continuing, then holding (no bust)" do
      let(:data) { [[1,2,3,4,5], [1,1,1,1,1]] }
      before do
        player.start_turn
        player.roll_dice
        player.decides_to_roll_again
        player.roll_dice
        player.decides_to_hold
      end

      subject { player.turns.last }
      let(:rolls) { subject.rolls }
      let(:last_roll) { rolls.last }

      it { should have(2).rolls }
      its(:score) { should == 1150 }
      it "records the proper actions" do
        rolls.map(&:action).should == [:roll, :hold]
      end
      it "has the proper number of dice thrown" do
        face_counts = rolls.map { |r| r.faces.size }
        face_counts.should == [5, 3]
      end
      its(:score) { should == 1150 }
    end

    context "after rolling, continuing twice" do
      let(:data) { [[1,2,3,4,5], [1,1,1,1,1], [1,2,3,4,5]] }
      before do
        player.start_turn
        player.roll_dice
        player.decides_to_roll_again
        player.roll_dice
        player.decides_to_roll_again
        player.roll_dice
        player.decides_to_hold
      end

      subject { player.turns.last }
      let(:rolls) { subject.rolls }
      let(:last_roll) { rolls.last }

      it "rolls all 5 dice" do
        last_roll.should have(5).faces
      end
    end

    context "accross two turns" do
      let(:data) { [[1,2,3,4,5], [3,3,3,4,4]] }
      before do
        player.start_turn
        player.roll_dice
        player.decides_to_hold

        player.start_turn
        player.roll_dice
        player.decides_to_hold
      end

      it "accumulates the player's score" do
        player.score.should == 450
      end
    end
  end

  describe "saving turn state" do
    let(:data) { [[1,2,3,4,5]] }
    before do
      player.start_turn
      player.roll_dice
      player.save_turn!

      player.reload
      player.decides_to_hold
      player.save_turn!
    end

    subject { Player.find(player.id) }

    it "has the new action in the reloaded player" do
      subject.last_roll.action.should == :hold
    end
  end

  describe "#last_turn" do
    let(:player) {
      Factory.create(:human_player,
        :turns => [Factory.create(:turn)])
    }

    it "returns the same object for all calls" do
      player.reload
      player.last_turn.should be player.last_turn
    end
  end

  describe "#last_roll" do
    let(:player) {
      Factory.create(:human_player,
        :turns => [Factory.create(:turn, :rolls => [Factory.create(:roll)])])
    }

    it "returns the same object for all calls" do
      player.reload
      player.last_roll.should be player.last_roll
    end
  end

end
