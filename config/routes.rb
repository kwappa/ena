Rails.application.routes.draw do
  root 'users#index'

  devise_for :users

  scope ':nick' do
    get '/', controller: :users, action: :show
  end
end
