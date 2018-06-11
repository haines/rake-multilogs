# frozen_string_literal: true

module Rake
  module Multilogs
    # Monkey-patches `Rake::Task` to group multitask output by task and display
    # it when all tasks have completed.
    module Task
      # Invoke all the prerequisites of a task in parallel, grouping output by
      # task and displaying it when all tasks have completed.
      # @return [void]
      def invoke_prerequisites_concurrently(task_args, invocation_chain)
        Forks.new(
          tasks: prerequisite_tasks,
          args: task_args,
          invocation_chain: invocation_chain
        ).invoke
      end
    end
  end
end
