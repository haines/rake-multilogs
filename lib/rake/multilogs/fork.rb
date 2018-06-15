# frozen_string_literal: true

module Rake
  module Multilogs
    # Invokes a task, prepending lines written to stdout and stderr with a
    # label.
    class Fork
      # @param task [Rake::Task] task to invoke.
      # @param args [Rake::TaskArguments] arguments to pass to the task.
      # @param invocation_chain [Rake::InvocationChain] chain of task invocations.
      # @param label [String] label to prepend to each line written.
      def initialize(task:, args:, invocation_chain:, label:)
        @task = task
        @args = args
        @invocation_chain = invocation_chain
        @label = label
      end

      # Invokes the task in a forked process, prepending lines written to stdout
      # and stderr with the configured label.
      #
      # @param lockfile [Lockfile] lockfile to prevent multiple processes writing output simultaneously.
      # @return [void]
      def invoke(lockfile:)
        @pid = fork { invoke_in_child_process(lockfile) }
      end

      # Waits for the invoked task to finish executing. Aborts if the task
      # fails.
      #
      # @return [void]
      def wait
        _, status = Process.wait2(@pid)
        exit status.exitstatus unless status.success?
      end

      # Convert to a string.
      #
      # @return [String] the task name.
      def to_s
        @task.to_s
      end

      private

      def invoke_in_child_process(lockfile)
        [STDOUT, STDERR].each do |io|
          io.reopen Labeller.new(out: io.dup, label: @label, lockfile: lockfile)
        end

        @task.application.standard_exception_handling do
          Multilogs.call_after_fork @task
          @task.send :invoke_with_call_chain, @args, @invocation_chain
        end
      end
    end
  end
end
