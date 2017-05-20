Rails.application.routes.draw do
  concern :routes do
    concern :commentable do |options|
      resource :comments, only: [:index, :create], **options
    end
    concern :likeable do |options|
      # NOTE: `likes` is noun NOT plurality.
      resource :likes, only: [:create, :destroy], **options
    end
    concern :pinable do |options|
      %i(pin unpin).each { |r| resource r, only: [:create], **options }
    end
    concern :favorable do |options|
      # NOTE: `favorites` is noun NOT plurality.
      resource :favorites, only: [:create, :destroy], **options
    end
    concern :recommendable do |options|
      resource :recommendation, only: [:create, :destroy], **options
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
