# frozen_string_literal: true

require "rake"
require "rake/multilogs/fork"
require "rake/multilogs/forks"
require "rake/multilogs/labeller"
require "rake/multilogs/labels"
require "rake/multilogs/lockfile"
require "rake/multilogs/task"
require "rake/multilogs/version"

module Rake
  # `Rake::Multilogs` prefixes the output of multitasks with the name of the
  # task that wrote each line, so that the interleaved logs are easier to
  # understand.
  #
  # This requires `Process.fork`, so is not supported on JRuby or Windows.
  module Multilogs
    class << self
      # Register a block to be called from the multitask before running its
      # prerequisites. This is called from the parent process before forking,
      # and will receive the multitask as a parameter.
      #
      # @example Handling database connections with Active Record
      #   Rake::Multilogs.before_fork do
      #     ActiveRecord::Base.connection.disconnect!
      #   end
      #
      # @param block [#to_proc] the block to call (must accept zero or one parameters)
      # @return [void]
      def before_fork(&block)
        @before_fork = block
      end

      # Register a block to be called before executing a task. This is called
      # from the child processes after forking, and from the parent process
      # after the prerequisites have completed and the child processes have
      # exited. In each case it will receive the task that is about to execute
      # as a parameter.
      #
      # @example Handling database connections with Active Record
      #   Rake::Multilogs.after_fork do
      #     ActiveRecord::Base.establish_connection
      #   end
      #
      # @param block [#to_proc] the block to call (must accept zero or one parameters)
      # @return [void]
      def after_fork(&block)
        @after_fork = block
      end

      # @private
      def call_before_fork(task)
        @before_fork&.call(task)
      end

      # @private
      def call_after_fork(task)
        @after_fork&.call(task)
      end
    end
  end
end

if Process.respond_to?(:fork)
  Rake::Task.prepend Rake::Multilogs::Task
else
  warn "\e[33mWARNING\e[0m: Rake::Multilogs is disabled because Process.fork is not available on this platform"
end
