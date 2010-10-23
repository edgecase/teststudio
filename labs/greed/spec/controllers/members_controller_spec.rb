require 'spec_helper'

describe MembersController do
  describe "GET new" do
    before do
      get :new
    end

    it { should render_template("new") }

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
      it { should assign_to(:member) }
      describe "the member" do
        subject { assigns[:member] }
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

      it { should respond_with(:success) }
      it { should render_template("new") }
      it { flash[:error].should =~ /unable to create/i }
    end
  end
end
