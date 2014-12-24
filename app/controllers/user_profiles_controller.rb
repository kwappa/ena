class UserProfilesController < ApplicationController
  before_action :set_user_and_profile

  respond_to :html

  def new
    if @user_profile.present?
      redirect_to edit_users_profile_path
    else
      @user_profile = UserProfile.new(user_id: @user.id)
    end
  end

  def edit
    unless @user_profile.present?
      redirect_to new_users_profile_path
    end
  end

  def create
    @user_profile = UserProfile.new(user_id: @user.id, body: user_profile_params[:body])
    @user_profile.save
    flash[:notice] = 'Resume created.'
    redirect_to home_path(@user.nick)
  end

  def update
    @user_profile.update_attributes(body: user_profile_params[:body])
    flash[:notice] = 'Resume updated.'
    redirect_to home_path(@user.nick)
  end

  private

  def set_user_and_profile
    redirect_to(root_path) and return unless view_context.myself?(current_user)
    @user = current_user
    @user_profile = current_user.profile
  end

  def user_profile_params
    params.require(:user_profile).permit(:user_id, :body)
  end
end
