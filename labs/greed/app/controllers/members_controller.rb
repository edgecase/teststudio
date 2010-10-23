class MembersController < ApplicationController
  def new
  end

  def create
    @member = Member.new(params[:member])
    if @member.save
      redirect_to member_path(@member)
    else
      flash[:error] = "Unable to create member"
      render "new"
    end
  end
end
