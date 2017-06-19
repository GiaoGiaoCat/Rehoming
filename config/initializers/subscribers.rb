subsribers = { post: %w(created liked commented), comment: %w(liked replied), user: %w(updated) }

subsribers.each do |key, value|
  value.each do |action|
    ActiveSupport::Notifications.subscribe("#{action}.#{key}") do |*args|
      event = ActiveSupport::Notifications::Event.new(*args)
      target_service =
        if "#{action}.#{key}" == 'updated.user'
          Users::RefreshCacheService
        else
          Feeds::SendService
        end
      target_service.create(name: event.name, sourceable: event.payload[:sourceable], handler: event.payload[:handler])
    end
  end
end
