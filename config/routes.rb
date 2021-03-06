Rails.application.routes.draw do

  use_doorkeeper
  root 'users#index'

  devise_for :users

  get 'user_root', controller: :users, action: :after_edit, method: :get

  namespace :users do
    get :list
    resource :user_resumes, controller: '/user_resumes', as: :resume, path: :resume, only: [:new, :edit, :create, :update]
  end

  resources :user_tags, only: [:index, :show]

  resources :teams do
    post :search_candidate_member
    post :assign_member
    post :withdraw_member
  end

  namespace :api do
    get :me
  end

  scope ':nick' do
    get '/', controller: :users, action: :show, as: :home

    scope :user_tags, controller: :user_tags, as: :user_tag, path: :tag do
      post :attach
      delete :detach
    end

    scope :resume_histories, controller: :users, as: :user_resume_histories, path: :resume_histories do
      get '/', action: :resume_histories
    end
  end
end
