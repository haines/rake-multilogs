# frozen_string_literal: true

module Rake
  module Multilogs
    # Invokes a list of tasks, prepending lines written to stdout and stderr
    # with the name of the task that wrote the line.
    class Forks
      # @param tasks [Enumerable<Rake::Task>] tasks to invoke.
      # @param args [Rake::TaskArguments] arguments to pass to the tasks.
      # @param invocation_chain [Rake::InvocationChain] chain of task invocations.
      def initialize(tasks:, args:, invocation_chain:)
        @forks = tasks.zip(Labels.new(tasks)).map { |task, label|
          Fork.new(
            task: task,
            args: args.new_scope(task.arg_names),
            invocation_chain: invocation_chain,
            label: label
          )
        }
      end

      # Invokes the tasks in forked processes, prepending lines written to
      # stdout and stderr with the name of the task that wrote the line. Aborts
      # if any of the tasks fail.
      #
      # @return [void]
      def invoke
        Lockfile.open do |lockfile|
          @forks
            .each { |fork| fork.invoke(lockfile: lockfile) }
            .each(&:wait)
        end
      end
    end
  end
end
