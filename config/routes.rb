Rails.application.routes.draw do
  concern :routes do
    concern :commentable do |options|
      resource :comments, :only => %i(index create), **options
    end
    concern :likeable do |options|
      # NOTE: `likes` is noun NOT plurality.
      resource :likes, :only => %i(create destroy), **options
    end
    concern :pinable do |options|
      resource :pin, :only => %i(create destroy), **options
    end
    concern :favorable do |options|
      # NOTE: `favorites` is noun NOT plurality.
      resource :favorite, :only => %i(create destroy), **options
    end
    concern :recommendable do |options|
      resource :recommendation, :only => %i(create destroy), **options
    end

    scope module: 'users' do
      resources :sessions, only: :create
    end

    resources :users, only: [] do
      %i(posts favorites).each { |r| resources r, only: :index, module: :users }
    end

    resources :posts, only: [:show] do
      %i(likeable commentable pinable favorable recommendable).each { |r| concerns r, module: :posts }
    end

    resources :comments, only: [] do
      %i(likeable commentable).each { |r| concerns r, module: :comments }
    end

    resources :forums, only: [:show] do
      scope module: :forums do
        resource :membership, only: :destroy
        resources :membership_requests, only: %i(index create update)
        resource :blocked_member, only: [:create, :destroy]

        resource :setting, only: [:update], controller: 'preferences'
        resources :members, only: [:index]
        resources :posts, only: %i(index create)
      end
      resource :preference, only: [:update], controller: 'forum_preferences', module: :users
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
