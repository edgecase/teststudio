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
    before do
      get :new
    end

    it { should render_template("new") }
    specify { controller.member.should be_new_record }

    it { controller.should respond_with_content_type("text/html") }
    it { controller.should respond_with(:success) }
  end

  # ------------------------------------------------------------------

  describe "POST create" do
    let!(:member) { Member.new }
    let(:member_attrs) { { "name" => "Joe", "email" => "abc@xyz.com" } }

    context "with good data" do
      before do
        expect_new(member, member_attrs)
        expect_save(member)
        post :create, :member => member_attrs
      end

      it { should redirect_to(member_path(member.id)) }
      specify { controller.member.should_not be_nil }
      describe "the member" do
        subject { controller.member }
        its(:name) { should == member_attrs[:name] }
        its(:email) { should == member_attrs[:email] }
      end
    end

    context "with bad data" do
      before do
        expect_new(member, member_attrs)
        expect_save(member, :invalid)
        post :create, :member => member_attrs
      end

      it { pending; should respond_with(:success) }
      specify { controller.member.should be member }
      it { pending; should render_template("new") }
      it { pending; flash[:error].should =~ /unable to create/i }
    end
  end

  # ------------------------------------------------------------------

  describe "GET show" do
    let(:member) { make_findable(:member) }
    before do
      get :show, :id => member.id
    end

    it { should render_template("show") }
    it "assigns member" do
      controller.member.should == member
    end
  end

  # ------------------------------------------------------------------

  describe "GET edit" do
    let(:member) { make_findable(:member) }
    before do
      get :edit, :id => member.id
    end

    it { should render_template("edit") }
    it "assigns member" do
      controller.member.should == member
    end
  end

  # ------------------------------------------------------------------

  describe "PUT update" do
    let(:member) { make_findable(:member) }
    let(:member_attrs) { { "name" => "Joe", "email" => "abc@xyz.com" } }

    context "when save succeeds" do
      before do
        expect_update(member, member_attrs)
        put :update, :member => member_attrs, :id => member.id
      end

      it { should redirect_to(member_path(member.id)) }
      specify { controller.member.should be(member) }
    end

    context "when save fails" do
      before do
        expect_update(member, member_attrs, :invalid)
        put :update, :member => member_attrs, :id => member.id
      end

      it { should render_template("edit") }
      specify { controller.member.should be(member) }
    end
  end

  # ------------------------------------------------------------------

  describe "DELETE destroy" do
    let(:member) { make_findable(:member) }

    before do
      expect_destruction(member)
      delete :destroy, :id => member.id
    end

    it { should redirect_to(members_path) }
  end
end
