class UserTagsController < ApplicationController
  TAGS_PER_PAGE = 100

  before_action :authenticate_user!, only: [:attach, :detach]
  before_action :set_target_user,    only: [:attach, :detach]

  layout 'users'

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

  def index
    @tags = UserTag.page(params[:page]).per(TAGS_PER_PAGE)
  end

  def show
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
