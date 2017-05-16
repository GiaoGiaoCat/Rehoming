Rails.application.routes.draw do
  concern :routes do
    concern :commentable do |options|
      resources :comments, only: [:index, :create], **options
    end

    concern :likeable do |options|
      %i(like dislike).each { |r| resource r, only: [:create], **options }
    end

    concern :favorable do |options|
      %i(favor unfavor).each { |r| resource r, only: [:create], **options }
    end

    scope module: 'users' do
      resources :sessions, only: :create
    end

    resources :users, only: [] do
      %i(posts favorites).each { |r| resources r, only: :index, module: :users }
    end

    resources :posts, only: [:show] do
      %i(likeable commentable).each { |r| concerns r, module: :posts }
      concerns :favorable, module: :posts
    end

    resources :comments, only: [] do
      %i(likeable commentable).each { |r| concerns r, module: :comments }
    end

    resources :groups, only: [] do
      scope module: :groups do
        %i(join quit rename).each { |r| resource r, only: [:create] }
        resources :members, only: [:index]
        resources :posts, only: [:index, :create]
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
