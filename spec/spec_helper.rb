$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'kafkadmin'
require 'rack/test'
require 'byebug'
require 'rspec'
require 'json'

ENV['RACK_ENV'] = 'test'

module RSpecMixin
  include Rack::Test::Methods
  def app() Kafkadmin::Web end
end

def execution_result(cmd = nil, exit_status = 0, stdout = nil, stderr = nil)
  Kafkadmin::CommandRunner::Result.new(
    cmd || 'some_command',
    exit_status,
    stdout || 'foo',
    stderr || ''
  )
end

RSpec.configure do |rspec|
  rspec.include RSpecMixin

  rspec.before(:each) do
    Kafkadmin.configure!({
      # Add overriding test config here
    })
  end
end
