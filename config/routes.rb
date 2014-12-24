Rails.application.routes.draw do
  root 'users#index'

  devise_for :users

  get 'user_root', controller: :users, action: :after_edit, method: :get

  scope ':nick' do
    get '/', controller: :users, action: :show, as: :user_profile
  end
end
