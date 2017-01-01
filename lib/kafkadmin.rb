require 'semantic_logger'
require 'thin'
require 'sinatra'
require "kafkadmin/version"
require "kafkadmin/config"
require "kafkadmin/logger_initializer"
require "kafkadmin/command_runner"
require "kafkadmin/command"
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

  def self.start_server!
    # Run as a daemon process if we pass --daemon
    if config.fetch(:daemon)
      puts "Starting Kafkadmin daemon..."
      Process.daemon(true)
    end

    Web.run!
  end

  def self.stop_server!
    pid = `pgrep -f kafkadmin`.chomp

    if pid =~ /\d+/
      puts "Killing Kafkadmin at PID #{pid}..."
      Process.kill('INT', pid.to_i)
    else
      puts 'Could not find a running Kafkadmin server.'
    end
  end
end
