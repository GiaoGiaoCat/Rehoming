Rails.application.routes.draw do
  concern :routes do
    concern :commentable do |options|
      resource :comments, only: [:create], **options
    end

    concern :likeable do |options|
      resource :likes, only: [:create], **options
      resource :dislikes, only: [:create], **options
    end

    concern :favorable do |options|
      resource :favorites, only: [:create], **options
      resource :unfavorites, only: [:create], **options
    end

    scope module: 'users' do
      resources :sessions, only: :create
    end

    resources :users, only: [] do
      resources :posts, only: :index, module: :users
    end

    resources :posts, only: [:show, :create] do
      concerns :likeable, module: :posts
      concerns :commentable, module: :posts
      concerns :favorable, module: :posts
    end

    resources :comments, only: [] do
      concerns :likeable, module: :comments
      concerns :commentable, module: :comments
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

  if Rails.env.production?
    constraints subdomain: 'api' do
      concerns :routes
    end
  end

  if Rails.env.development? || Rails.env.test?
    concerns :routes # for development
  end
end
