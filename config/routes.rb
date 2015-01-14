Rails.application.routes.draw do

  root 'users#index'

  devise_for :users

  get 'user_root', controller: :users, action: :after_edit, method: :get

  namespace :users do
    get :list
    resource :user_resumes, controller: '/user_resumes', as: :resume, path: :resume
  end

  scope ':nick' do
    get '/', controller: :users, action: :show, as: :home
  end
end
