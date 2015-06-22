$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'rci'

RSpec.configure do |config|

  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  config.order = 'random'
end
