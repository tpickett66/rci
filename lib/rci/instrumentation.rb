require 'redis'
require 'active_support/notifications'

module RCI
  module Instrumentation
    def call(command, &block)
      ActiveSupport::Notifications.instrument('redis', command: command.first) do
        super
      end
    end
  end
end
