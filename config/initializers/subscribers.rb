subsribers = { post: %w(created liked commented), comment: %w(liked replied) }

subsribers.each do |key, value|
  value.each do |action|
    ActiveSupport::Notifications.subscribe("#{action}.#{key}") do |*args|
      event = ActiveSupport::Notifications::Event.new(*args)
      Feeds::SendService.create({
        name: event.name, sourceable: event.payload[:sourceable], handler: event.payload[:handler]
      })
    end
  end
end
