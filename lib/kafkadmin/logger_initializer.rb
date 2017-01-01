
module Kafkadmin
  class LoggerInitializer

    # Just setup SemanticLogger
    def self.init!
      SemanticLogger.add_appender(
        io: $stdout,
        formatter: :color
      )
      SemanticLogger.add_appender(
        file_name: Kafkadmin.config.fetch(:log_dir) + '/kafkadmin.log',
        formatter: :color
      )

      SemanticLogger[LoggerInitializer].info 'Logging initialized'
    end
  end
end
