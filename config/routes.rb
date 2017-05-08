Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  scope module: 'users' do
    resources :sessions, only: :create
  end
  resources :posts, only: [:create]

  # namespace :groups do
  resources :groups, only: [] do
    resources :members, only: [:index], module: :groups
  end
end
