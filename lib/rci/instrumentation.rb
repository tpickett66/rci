require 'redis'
require 'active_support/notifications'

module RCI
  module Instrumentation
    def call(command, &block)
      payload = extract_notification_payload_from(command)
      ActiveSupport::Notifications.instrument("#{ Commands.command_type(command) }.redis", payload) do
        super
      end
    end

    private

    def extract_notification_payload_from(command_array)
      Commands.extract_command(command_array)
    end
  end
end
