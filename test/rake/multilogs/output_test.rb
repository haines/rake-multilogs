# frozen_string_literal: true

require_relative "../../test_helper"

module Rake
  module Multilogs
    class OutputTest < Test
      def test_labelled_output
        output, status = rake <<~RAKEFILE
          tasks = [:one, :two, :three]

          tasks.each_with_index do |name, index|
            task name do
              printf "Hello from %s\n", name
              printf "Goodbye from %s\n", name
            end
          end

          multitask :default => tasks
        RAKEFILE

        assert_labelled_output_matches(
          {
            "one  " => [
              "Hello from one",
              "Goodbye from one"
            ],
            "two  " => [
              "Hello from two",
              "Goodbye from two"
            ],
            "three" => [
              "Hello from three",
              "Goodbye from three"
            ]
          },
          output
        )

        assert status.success?
      end

      def test_abort_on_failure
        output, status = rake <<~RAKEFILE
          tasks = [:one, :two]

          tasks.each do |name|
            task name do
              raise "\#{name} failed!"
            end
          end

          multitask :default => tasks
        RAKEFILE

        assert_labelled_output_contains(
          {
            "one" => [
              "rake aborted!",
              "one failed!",
              "Tasks: TOP => default => one"
            ],
            "two" => [
              "rake aborted!",
              "two failed!",
              "Tasks: TOP => default => two"
            ]
          },
          output
        )

        refute status.success?
      end
    end
  end
end
