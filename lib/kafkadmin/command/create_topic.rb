
module Kafkadmin
  module Command
    class CreateTopic

      ARGUMENTS = [
        :topic_name,
        :partitions,
        :replication_factor
      ]

      def initialize(opts)
        @topic_name         = opts[:name]
        @partitions         = opts[:partitions]
        @replication_factor = opts[:replication_factor]

        @errors = []
      end

      def command_string
        if valid?
          [
            command_binary,
            main_command,
            zookeeper,
            replication_factor,
            partitions,
            topic_name
          ].delete_if(&:nil?).join(" ")
        else
          raise "Command is invalid. Call #valid? before generating the command string."
        end
      end

      def valid?
        result = ARGUMENTS.dup.map do |arg|
          validate(arg)
        end

        result.all? {|v| v.to_s == 'true' }
      end

      def errors
        @errors
      end

      private

      def validate(arg)
        case arg
        when :topic_name
          # This check cleans up our "controller" - validation happens inside
          # the command.
          if @topic_name.nil? || @topic_name.empty?
            @errors << "Topic name must be provided."
          elsif @topic_name =~ /^[a-zA-Z0-9\._\-]+$/
            true
          else
            @errors << "The name \"#{@topic_name}\" is not a valid Kafka topic name."
          end
        when :partitions
          if @partitions.nil? || (@partitions == '')
            @errors << "Partition count must be provided."
          elsif @partitions.to_i > 0
            true
          else
            @errors << "Partition count must be greater than 0. Got #{@partitions}."
          end
        else
          true
        end
      end

      def command_binary
        "/opt/kafka/bin/kafka-topics.sh"
      end

      def main_command
        "--create"
      end

      def zookeeper
        "--zookeeper 192.168.35.10"
      end

      def replication_factor
        if @replication_factor
          "--replication-factor #{@replication_factor.to_i}"
        end
      end

      def partitions
        "--partitions #{@partitions.to_i}"
      end

      def topic_name
        "--topic #{@topic_name}"
      end
    end
  end
end
