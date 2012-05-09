require 'spec_helper'

describe MembersController do
  Given(:member_attrs) { { "name" => "Jim", "email" => "jim@xyz.com", "rank" => "1000" } }
  Given!(:member) { Member.new(member_attrs) }

  describe "GET index" do
    Given(:member_list) { [member] }
    Given { flexmock(Member).should_receive(:by_rank).once.and_return([member]) }

    When { get :index }

    Then { response.code.should == "200" }
    Then { response.should render_template("index") }
    Then { assigns(:members).should == member_list }
  end

  describe "GET show" do
    Given { flexmock(Member).should_receive(:find).with("1").once.and_return(member) }

    When { get :show, id: "1" }

    Then { response.code.should == "200" }
    Then { response.should render_template("show") }
    Then { assigns(:member).should == member }
  end

  describe "GET new" do
    Given { flexmock(Member, :new => member) }

    When { get :new }

    Then { response.code.should == "200" }
    Then { response.should render_template("new") }
    Then { assigns(:member).should == member }
  end

  describe "POST create" do
    Given(:id) { "5123" }
    Given { flexmock(Member).should_receive(:new).with(member_attrs).once.and_return(member) }
    Given { flexmock(member).should_receive(:save).once.and_return {
        flexmock(member, id: id, :new_record? => false)
        valid
      }
    }

    When { post :create, member: member_attrs }

    context "with valid paramaters" do
      Given(:valid) { true }
      Then { response.should redirect_to member_path(member) }
      Then { flash[:alert].should =~ /member created/i }
    end

    context "with invalid paramaters" do
      Given(:valid) { false }
      Then { response.should render_template("new") }
      Then { assigns(:member).should == member }
    end
  end

  describe "GET edit" do
    Given(:id) { "4215" }
    Given { flexmock(member, id: id, :new_record? => false) }
    Given { flexmock(Member, :find => member) }

    When { get :edit, id: id }

    Then { response.code.should == "200" }
    Then { response.should render_template("edit") }
    Then { assigns(:member).should == member }
  end

  describe "POST update" do
    Given(:id) { "51232" }
    Given { flexmock(member, id: id, :new_record? => false) }
    Given { flexmock(Member).should_receive(:find).with(id).and_return(member) }
    Given { flexmock(member).should_receive(:update_attributes).with(member_attrs).once.and_return(valid) }

    When { post :update, id: id, member: member_attrs }

    context "with valid attributes" do
      Given(:valid) { true }
      Then { response.should redirect_to(member_path(member)) }
    end

    context "with valid attributes" do
      Given(:valid) { false }
      Then { response.should render_template("edit") }
      Then { assigns(:member).should == member }
    end
  end

  describe "DELETE destroy" do
    Given(:id) { "3124" }
    Given { flexmock(member, id: id, :new_record? => false) }
    Given { flexmock(Member).should_receive(:find).with(id).once.and_return(member) }
    Given { flexmock(member).should_receive(:destroy).with().once.and_return(nil) }

    When { delete :destroy, id: id }

    Then { response.should redirect_to(members_path) }
  end

end
