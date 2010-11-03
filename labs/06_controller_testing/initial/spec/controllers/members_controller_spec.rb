require 'spec_helper'

describe MembersController do
  describe "GET index" do
    before do
      flexmock(Member).should_receive(:by_rank).once.and_return(:members)
      get :index
    end

    it { should render_template("index") }
    it "assigns member list" do
      controller.members.should == :members
    end
  end

  # ------------------------------------------------------------------

  describe "GET new" do
    # Add specs
  end

  # ------------------------------------------------------------------

  describe "POST create" do
    context "with good data" do
      # Add specs
    end

    context "with bad data" do
      # Add specs
    end
  end

  # ------------------------------------------------------------------

  describe "GET show" do
    # Add specs
  end

  # ------------------------------------------------------------------

  describe "GET edit" do
    # Add specs
  end

  # ------------------------------------------------------------------

  describe "PUT update" do
    context "when save succeeds" do
      # Add specs
    end

    context "when save fails" do
      # Add specs
    end
  end

  # ------------------------------------------------------------------

  describe "DELETE destroy" do
    # Add specs
  end
end
