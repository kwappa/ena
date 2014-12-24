class UserProfilesController < ApplicationController
  before_action :set_user_profile, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @user_profiles = UserProfile.all
    respond_with(@user_profiles)
  end

  def show
    respond_with(@user_profile)
  end

  def new
    @user_profile = UserProfile.new
    respond_with(@user_profile)
  end

  def edit
  end

  def create
    @user_profile = UserProfile.new(user_profile_params)
    @user_profile.save
    respond_with(@user_profile)
  end

  def update
    @user_profile.update(user_profile_params)
    respond_with(@user_profile)
  end

  def destroy
    @user_profile.destroy
    respond_with(@user_profile)
  end

  private
    def set_user_profile
      @user_profile = UserProfile.find(params[:id])
    end

    def user_profile_params
      params.require(:user_profile).permit(:user_id, :body)
    end
end
