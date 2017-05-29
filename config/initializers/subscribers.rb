subsribers = { post: %w(created liked commented), comment: %w(liked replied) }

subsribers.each do |key, value|
  value.each do |action|
    ActiveSupport::Notifications.subscribe("#{action}.#{key}") do |*args|
      event = ActiveSupport::Notifications::Event.new(*args)
      Feeds::Hook.create(event.name, event.transaction_id, event.payload)
    end
  end
end
