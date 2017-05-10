Rails.application.routes.draw do
  concern :routes do
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

  constraints subdomain: 'api' do
    concerns :routes
  end

  if Rails.env.development?
    concerns :routes # for development
  end
end
