require 'spec_helper'

module RCI
  RSpec.describe Instrumentation do
    let(:redis) { Redis.new }

    before do
      RCI.attach_instrumentation_to(redis)
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

      it 'must emit events to "read.redis" for commands that strictly read values' do
        event_received = false
        with_subscription_to('read.redis', ->(*_) { event_received = true }) do
          redis.keys('abc123*')
          expect(event_received).to eq true
        end
      end

      it 'must emit events to "write.redis" for commands that may alter values' do
        event_received = false
        with_subscription_to('write.redis', ->(*_) { event_received = true }) do
          redis.psetex('__RCI-string-key-for-testing__', 1, 'This is my expiring string')
          expect(event_received).to eq true
        end
      end
    end
  end
end
