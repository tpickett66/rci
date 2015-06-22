require 'spec_helper'

module RCI
  RSpec.describe Instrumentation do
    let(:redis) { Redis.new }

    before do
      redis.client.singleton_class.send :prepend, RCI::Instrumentation
    end

    describe '#call(command, &block)' do
      it 'must emit an ActiveSupport::Notification event with the name ending in "redis"' do
        begin
          event_received = false
          subscription = ActiveSupport::Notifications.subscribe(/redis\z/) do |*args|
            event_received = true
          end
          redis.keys('abc123*')
          expect(event_received).to eq true
        ensure
          ActiveSupport::Notifications.unsubscribe(subscription)
        end
      end

      it 'must continue to return the original result of the command' do
        expect(redis.ping).to eq 'PONG'
      end

      it 'must include the name of the command as part of the notification payload' do
        begin
          caught_payload = {}
          subscription = ActiveSupport::Notifications.subscribe(/redis\z/) do |name, started, finished, unique_id, payload|
            caught_payload = payload
          end
          redis.keys('abc123*')
          expect(caught_payload[:command]).to eq :keys
        ensure
          ActiveSupport::Notifications.unsubscribe(subscription)
        end
      end
    end
  end
end
