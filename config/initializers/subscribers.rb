subsribers = { post: %w(created liked commented), comment: %w(liked replied) }

subsribers.each do |key, value|
  value.each do |action|
    ActiveSupport::Notifications.subscribe("#{action}.#{key}") do |*args|
      event = ActiveSupport::Notifications::Event.new(*args)
      Services::Feeds::Create.call(event)
    end
  end
end
