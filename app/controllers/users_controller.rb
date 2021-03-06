class UsersController < ApplicationController
  MEMBERS_PER_PAGE   = 20
  HISTORIES_PER_PAGE = 10

  before_action :prepare_user, only: [:show, :resume_histories, :resume_history]

  layout 'users'

  def index
    if user_signed_in?
      redirect_to(home_path(current_user.nick))
    end
  end

  def show
  end

  def list
    relation = case params[:sort]
               when 'recent' then User.recent
               when 'member_number' then User.order_by_member_number
               else User.order_by_nick
               end
    relation = relation.reverse_order if params[:order] == 'desc'
    @members = relation.page(params[:page]).per(MEMBERS_PER_PAGE)
  end

  def resume_histories
    @histories = @user.resume_histories.order(:updated_at).reverse_order.page(params[:page]).per(HISTORIES_PER_PAGE)
  end

  def after_edit
    redirect_to home_path(current_user.nick)
  end

  def prepare_user
    if request.path_info.start_with?('/users')
      @user = current_user
    else
      @user = User.find_by(nick: params[:nick])
    end
    raise ActiveRecord::RecordNotFound unless @user
  end
end
