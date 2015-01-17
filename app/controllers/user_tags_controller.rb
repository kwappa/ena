class UserTagsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_target_user

  def attach
    @user.tag_keyword(params[:name])
    redirect_to home_path(@user.nick)
  end

  def detach
    if view_context.myself?(@user)
      tag = UserTag.find(params[:tag_id])
      @user.detach(tag) if tag.present?
    end
    redirect_to home_path(@user.nick)
  end

  private

  def set_target_user
    @user = User.find_by(nick: params[:nick])
    raise ActiveRecord::RecordNotFound unless @user
  end

  def user_tag_params
    params.require(:user_tag).permit(:user_id, :name)
  end
end
