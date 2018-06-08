# frozen_string_literal: true

module Rake
  module Multilogs
    # @private
    class Forks
      def initialize(tasks:, args:, invocation_chain:)
        @forks = tasks.map { |task|
          Fork.new(
            task: task,
            args: args.new_scope(task.arg_names),
            invocation_chain: invocation_chain
          )
        }
      end

      def invoke
        @forks
          .each(&:invoke)
          .each(&:wait)
          .each(&:report)

        abort if @forks.any?(&:failed?)
      end
    end
  end
end
