class UsersController < ApplicationController
  def index
  end

  def show
    if request.path_info.start_with?('/users')
      @user = current_user
    else
      @user = User.find_by(nick: params[:nick])
    end
    raise ActiveRecord::RecordNotFound unless @user
  end

  def after_edit
    redirect_to home_path(current_user.nick)
  end
end
