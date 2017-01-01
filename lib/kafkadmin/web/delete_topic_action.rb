
module Kafkadmin
  class Web < Sinatra::Base
    class DeleteTopicAction
      include SemanticLogger::Loggable

      def initialize(args)
        @args = args
      end

      def execute!
        # Create the command
        cmd = Command::DeleteTopic.new(@args)

        if cmd.valid?
          # If it's valid, execute it
          result = CommandRunner.execute(cmd.command_string)

          # If it succeeded, awesome
          if result.success?
            logger.info "Successfully deleted topic", command: cmd.command_string
            @response = successful_response(result)
            @success = true
          else
            # Otherwise present the failure
            @response = kafka_error_response(result)
            @success = false
          end
        else
          logger.error "Invalid command processed", errors: cmd.errors
          # If the original command was invalid, give a
          # different error
          @response = invalid_command_response(cmd)
          @success  = false
        end
      end

      def success?
        if @success.nil?
          raise('Action not yet completed')
        else
          @success 
        end
      end

      def response
        if @response.nil?
          raise('Action not yet completed')
        else
          @response 
        end
      end

      private

      def invalid_command_response(cmd)
        {
          status: 'error',
          message: 'The provided parameters were invalid.',
          errors: cmd.errors
        }
      end

      def successful_response(execution_result)
        {
          status: 'ok',
          command: {
            command_string: execution_result.command,
            exit_status: execution_result.exit_status,
            stdout: execution_result.stdout,
            stderr: execution_result.stderr
          }
        }
      end

      def kafka_error_response(execution_result)
        {
          status: 'error',
          message: 'Kafka returned a non-zero exit status.',
          command: {
            command_string: execution_result.command,
            exit_status: execution_result.exit_status,
            stdout: execution_result.stdout,
            stderr: execution_result.stderr
          }
        }
      end
    end
  end
end
