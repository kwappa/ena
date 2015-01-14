class UserResumesController < ApplicationController
  before_action :set_user_and_resume

  respond_to :html
  layout 'users'

  def new
    if @user_resume.present?
      redirect_to edit_users_resume_path
    else
      @user_resume = UserResume.new(user_id: @user.id)
    end
  end

  def edit
    unless @user_resume.present?
      redirect_to new_users_resume_path
    end
  end

  def create
    @user_resume = UserResume.new(user_id: @user.id, body: user_resume_params[:body])
    @user_resume.save
    flash[:notice] = 'Resume created.'
    redirect_to home_path(@user.nick)
  end

  def update
    @user_resume.update_attributes(body: user_resume_params[:body])
    flash[:notice] = 'Resume updated.'
    redirect_to home_path(@user.nick)
  end

  private

  def set_user_and_resume
    redirect_to(root_path) and return unless view_context.myself?(current_user)
    @user = current_user
    @user_resume = current_user.resume
  end

  def user_resume_params
    params.require(:user_resume).permit(:user_id, :body)
  end
end
