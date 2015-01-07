Rails.application.routes.draw do

  root 'users#index'

  devise_for :users

  get 'user_root', controller: :users, action: :after_edit, method: :get

  namespace :users do
    get :list
    resource :user_profiles, controller: '/user_profiles', as: :profile, path: :profile
  end

  scope ':nick' do
    get '/', controller: :users, action: :show, as: :home
  end
end
