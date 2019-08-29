# frozen_string_literal: true

module Rake
  module Multilogs
    # Monkey-patches `Rake::Task` to prefix multitask output lines with the
    # name of the task that wrote the line.
    module Task
      # Invoke all the prerequisites of a task in parallel. Each line written to
      # stdout or stderr will be prefixed with the name of the task that wrote
      # the line.
      #
      # @param task_args [Rake::TaskArguments] arguments to pass to the task.
      # @param invocation_chain [Rake::InvocationChain] chain of task invocations.
      # @return [void]
      def invoke_prerequisites_concurrently(task_args, invocation_chain)
        Multilogs.call_before_fork self

        Forks.new(
          tasks: prerequisite_tasks,
          args: task_args,
          invocation_chain: invocation_chain
        ).invoke

        Multilogs.call_after_fork self
      end
    end
  end
end
