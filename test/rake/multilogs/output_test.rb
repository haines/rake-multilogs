# frozen_string_literal: true

require_relative "../../test_helper"

module Rake
  module Multilogs
    class OutputTest < Test
      def test_group_output_by_task
        output, status = rake <<~RAKEFILE
          tasks = [:one, :two]

          tasks.each do |name|
            task name do
              3.times do
                snooze
                puts name
              end
            end
          end

          multitask :default => tasks
        RAKEFILE

        assert_equal <<~OUTPUT, output
          one
          one
          one
          two
          two
          two
        OUTPUT

        assert status.success?
      end

      def test_abort_on_failure
        output, status = rake <<~RAKEFILE
          tasks = [:one, :two]

          tasks.each do |name|
            task name do
              3.times do
                snooze
                puts name
              end
              raise "\#{name} failed!"
            end
          end

          multitask :default => tasks
        RAKEFILE

        assert_match <<~OUTPUT, output
          one
          one
          one
          rake aborted!
          one failed!
        OUTPUT

        assert_match <<~OUTPUT, output
          two
          two
          two
          rake aborted!
          two failed!
        OUTPUT

        refute status.success?
      end
    end
  end
end
