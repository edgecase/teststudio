class MembersController < ApplicationController
  assume(:members) {  }
  assume(:member) { Member.find(params['id']) }

  def index
    self.members = Member.by_rank
  end

  def new
    self.member = Member.new
  end

  def create
    self.member = Member.new(params[:member])
    if member.save
      redirect_to member_path(member)
    else
      flash[:error] = "Unable to create member"
      render "new"
    end
  end

  def edit
  end

  def update
    if member.update_attributes(params[:member])
      redirect_to member_path(member)
    else
      render "edit"
    end
  end

  def destroy
    member.destroy
    redirect_to members_path
  end
end
