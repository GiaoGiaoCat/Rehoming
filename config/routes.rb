Rails.application.routes.draw do
  scope module: 'users' do
    resources :sessions, only: :create
  end
  resources :posts, only: [:create]

  resources :groups, only: [] do
    scope module: :groups do
      resource :join, only: [:create]
      resource :quit, only: [:create]
      resources :members, only: [:index]
      resource :rename, only: [:create]
    end
  end
end
