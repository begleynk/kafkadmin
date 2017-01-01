require 'yaml'

module Kafkadmin
  class Config

    CONFIG_FILE_PATH = Dir.home + '/.kafkadmin'

    AVAILABLE_CONFIGS = [
      :daemon,
      :kafka_path,
      :log_dir
    ]

    DEFAULTS = {
      :daemon     => false,
      :kafka_path => '/opt/kafka',
      :log_dir    => './logs'
    }

    def initialize(opts = {})
      # Each step here overrides the config values
      # set in the previous step.
      load_default_configs
      load_config_file
      load_provided_config(opts)
    end

    def fetch(key)
      @configs.fetch(key) { raise("Requested invalid config option #{key}") }
    end

    def values
      @configs
    end

    private

    def load_default_configs
      @configs = DEFAULTS.dup
    end

    def load_config_file
      if File.exists?(CONFIG_FILE_PATH)
        file_values = YAML.load(File.read(CONFIG_FILE_PATH))
        if file_values.is_a? String
          abort "Config file at #{CONFIG_FILE_PATH} is invalid. Expected YAML, got: \n#{file_values}"
        end
        # File overrides
        @configs = @configs.merge(extract_values(file_values))
      else
        # TODO: Tell the user the config file could not be
        # found via a logger
      end
    end

    def load_provided_config(opts)
      @configs = @configs.merge(extract_values(opts))
    end

    # Only take out values that are valid config keys
    def extract_values(opts_hash)
      # Turns string keys into symbols just in case
      opts_hash = opts_hash.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
      opts_hash.dup.delete_if {|key, _val| !AVAILABLE_CONFIGS.include?(key) }
    end
  end
end
