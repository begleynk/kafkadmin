require 'sinatra'
require "kafkadmin/version"
require "kafkadmin/config"
require "kafkadmin/web"

module Kafkadmin
  class << self
    def config
      @config || raise('Config not initialized')
    end
    
    def config=(conf)
      @config = conf
    end
  end

  def self.configure!(opts)
    self.config = Config.new(opts)
  end
end
