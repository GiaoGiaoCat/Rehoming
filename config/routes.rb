Rails.application.routes.draw do
  concern :routes do
    concern :commentable do
      resource :comment, only: [:create]
    end

    concern :likeable do |options|
      resource :likes, only: [:create], **options
      resource :dislikes, only: [:create], **options
    end

    scope module: 'users' do
      resources :sessions, only: :create
    end

    resources :posts, only: [:show, :create] do
      concerns :commentable
      concerns :likeable, module: :posts
    end

    resources :comments, only: [] do
      concerns :commentable
      concerns :likeable, module: :comments
    end

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
