require 'spec_helper'

module RCI
  RSpec.describe Instrumentation do
    let(:redis) { Redis.new }

    before do
      redis.client.singleton_class.send :prepend, RCI::Instrumentation
    end

    describe '#call(command, &block)' do
      it 'must emit an ActiveSupport::Notification event with the name ending in "redis"' do
        event_received = false
        with_subscription_to(/redis\z/, ->(*_) { event_received = true }) do
          redis.keys('abc123*')
          expect(event_received).to eq true
        end
      end

      it 'must continue to return the original result of the command' do
        expect(redis.ping).to eq 'PONG'
      end

      it 'must include the name of the command as part of the notification payload' do
        caught_payload = {}
        with_subscription_to(/redis\z/, ->(*args) { caught_payload = args.last }) do
          redis.keys('abc123*')
          expect(caught_payload[:command]).to eq :keys
        end
      end

      it 'must include a subcommand key in the payload for script commands' do
        caught_payload = {}
        with_subscription_to(/redis\z/, ->(*args) { caught_payload = args.last }) do
          redis.script(:exists, 'foo')
          expect(caught_payload[:command]).to eq :script
          expect(caught_payload[:subcommand]).to eq :exists
        end
      end
    end
  end
end
