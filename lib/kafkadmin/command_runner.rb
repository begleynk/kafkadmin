require 'open3'

module Kafkadmin
  class CommandRunner

    def self.execute(command)
      new(command).execute
    end

    def initialize(command)
      @command = command
    end

    def execute
      _stdin, stdout, stderr, wait_thr = Open3.popen3(@command)

      Result.new(@command, wait_thr.value.to_i, stdout.read, stderr.read)
    end

    Result = Struct.new(:command, :exit_status, :stdout, :stderr) do
      def success?
        exit_status == 0
      end

      def failure?
        !success?
      end
    end
  end
end
