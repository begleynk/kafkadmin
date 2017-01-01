
module Kafkadmin
  module Command
    class DeleteTopic

      ARGUMENTS = [
        :topic_name,
      ]

      def initialize(opts)
        @topic_name = opts[:name]

        @errors     = []
      end

      def command_string
        [
          command_binary,
          main_command,
          zookeeper,
          topic_name
        ].delete_if(&:nil?).join(" ")
      end

      def errors
        @errors
      end

      def valid?
        if @topic_name.nil? || @topic_name.empty?
          @errors << "Topic name must be provided."
          false
        elsif @topic_name =~ /^[a-zA-Z0-9\._\-]+$/
          true
        else
          @errors << "The name \"#{@topic_name}\" is not a valid Kafka topic name."
          false
        end
      end

      private

      def command_binary
        "#{Kafkadmin.config.fetch(:kafka_path)}/bin/kafka-topics.sh"
      end

      def main_command
        "--delete"
      end

      def zookeeper
        "--zookeeper #{Kafkadmin.config.fetch(:zookeeper_string)}"
      end

      def topic_name
        "--topic #{@topic_name}"
      end
    end
  end
end
