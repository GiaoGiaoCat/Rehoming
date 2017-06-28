Rails.application.routes.draw do
  concern :routes do
    concern :commentable do |options|
      resources :comments, :only => %i(index create), **options
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
      collection do
        get 'me', to: 'users#show'
        match 'me', to: 'users#update', via: %i(patch put)
      end
    end
    %i(posts favorites forums).each { |r| resources r, only: :index, module: :users }

    resources :posts, only: [:show] do
      %i(likeable commentable pinable favorable recommendable).each { |r| concerns r, module: :posts }
    end

    resources :comments, only: [] do
      %i(likeable).each { |r| concerns r, module: :comments }
    end

    resources :forums, only: %i(show create) do
      scope module: :forums do
        resource :membership, only: :destroy
        resources :membership_requests, only: %i(index create update)
        resources :blocked_members, only: %i(index create destroy)

        resource :setting, only: [:update], controller: 'preferences'
        resources :posts, only: %i(index create)
        resources :invitations, only: %i(create)
        resources :members, only: %i(index destroy) do
          resource :admin, only: %i(create destroy)
          resource :collaborator, only: :destroy
        end
        resources :collaborators, only: :create
      end
      resource :preference, only: [:update], controller: 'forum_preferences', module: :users
    end
    resources :feeds, only: %i(index update)
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
