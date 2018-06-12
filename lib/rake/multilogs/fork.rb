# frozen_string_literal: true

module Rake
  module Multilogs
    # @private
    class Fork
      def initialize(task:, args:, invocation_chain:)
        @task = task
        @args = args
        @invocation_chain = invocation_chain
      end

      def invoke
        @reader, @writer = IO.pipe
        @pid = fork { invoke_in_child_process }
        @writer.close
      end

      def wait
        _, @status = Process.wait2(@pid)
      end

      def report
        puts @reader.read
      end

      def failed?
        !@status.success?
      end

      def to_s
        @task.to_s
      end

      private

      def invoke_in_child_process
        @reader.close
        [STDOUT, STDERR].each do |stream|
          stream.reopen @writer
        end

        @task.application.standard_exception_handling do
          Multilogs.call_after_fork @task
          @task.send :invoke_with_call_chain, @args, @invocation_chain
        end
      end
    end
  end
end
