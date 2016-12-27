
module Kafkadmin
  class Config

    AVAILABLE_CONFIGS = [
      :daemon,
      :kafka_path
    ]

    DEFAULTS = {
      :daemon => false,
      :kafka_path => '/opt/kafka'
    }

    def initialize(opts = {})
      @configs = AVAILABLE_CONFIGS.dup.reduce(Hash.new) do |values, config_option|
        # Use the provided option and fall back to defaults
        values[config_option] = opts.fetch(config_option) { DEFAULTS[config_option] }
        values
      end
    end

    def fetch(key)
      @configs.fetch(key) { raise("Requested invalid config option #{key}") }
    end

    def values
      @configs
    end
  end
end
