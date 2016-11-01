require 'build_pack'
require 'pry'
require 'webmock/rspec'
require 'helpers'

def suppress_output(config)
  config.before { allow($stdout).to receive(:puts) }
end

RSpec.configure do |config|
  suppress_output(config)
  config.include Helpers
end
