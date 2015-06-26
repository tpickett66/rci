$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'rci'

Dir[File.join(File.dirname(__FILE__), 'support', '**', '*.rb')].each do |f|
  require f
end

RSpec.configure do |config|

  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  config.order = 'random'

  config.include NotificationHelpers

  config.before(:all) do
    RCI::Commands.discover!(Redis.new)
  end
end
