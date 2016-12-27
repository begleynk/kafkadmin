$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'kafkadmin'

RSpec.configure do |rspec| 
  rspec.before(:each) do
    Kafkadmin.configure!({
      # Add overriding test config here
    })
  end
end
