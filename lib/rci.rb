require "rci/version"
require 'rci/instrumentation'
require 'rci/commands'

module RCI
  def self.setup(redis)
    discover_commands(redis)
    attach_instrumentation!
  end

  def self.attach_instrumentation_to(redis)
    discover_commands(redis)
    redis.client.singleton_class.send(:prepend, RCI::Instrumentation)
  end

  private

  def self.attach_instrumentation!
    Redis::Client.send(:prepend, RCI::Instrumentation)
  end

  def self.discover_commands(redis)
    Commands.discover!(redis)
  end
end
