
module Kafkadmin
  class Config

    AVAILABLE_CONFIGS = [
      :daemon
    ]

    DEFAULTS = {
      :daemon => false
    }

    def initialize(opts = {})
      @configs = AVAILABLE_CONFIGS.dup.reduce(Hash.new) do |values, config_option|
        # Use the provided option and fall back to defaults
        values[config_option] = opts.fetch(config_option) { DEFAULTS[config_option] }
        values
      end
    end

    def [](key)
      @configs[key]
    end

    def fetch(key)
      @configs.fetch(key)
    end

    def values
      @configs
    end
  end
end
