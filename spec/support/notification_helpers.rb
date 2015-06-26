module NotificationHelpers
  def with_subscription_to(matcher, notification_proc)
    subscription = ActiveSupport::Notifications.subscribe(matcher, notification_proc)
    yield
  ensure
    ActiveSupport::Notifications.unsubscribe(subscription)
  end
end
