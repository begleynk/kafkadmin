# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kafkadmin/version'

Gem::Specification.new do |spec|
  spec.name          = "kafkadmin"
  spec.version       = Kafkadmin::VERSION
  spec.authors       = ["Niklas Begley"]
  spec.email         = ["niklas.begley@gmail.com"]

  spec.summary       = %q{A small web API for Kafka administration}
  spec.description   = %q{A small web API to be run on Kafka brokers that provides administration commands, by allowing access to Kafka's own binaries.}
  spec.homepage      = 'https://github.com/begleynk/kafkadmin'
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = ['kafkadmin']
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'sinatra', '~> 1.4', '>= 1.4.7'

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "byebug"
end
