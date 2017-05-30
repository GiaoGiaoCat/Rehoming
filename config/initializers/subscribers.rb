subsribers = { post: %w(created liked commented), comment: %w(liked replied) }

subsribers.each do |key, value|
  value.each do |action|
    ActiveSupport::Notifications.subscribe("#{action}.#{key}") do |*args|
      event = ActiveSupport::Notifications::Event.new(*args)
      Feeds::Hook.create(name: event.name, transaction_id: event.transaction_id, payload: event.payload)
    end
  end
end
