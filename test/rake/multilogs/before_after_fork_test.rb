# frozen_string_literal: true

require_relative "../../test_helper"

module Rake
  module Multilogs
    class BeforeAfterForkTest < Test
      def test_before_after_fork
        output, = rake <<~RAKEFILE
          Rake::Multilogs.before_fork do |task|
            puts "before_fork: \#{task.name}"
          end

          Rake::Multilogs.after_fork do |task|
            puts "after_fork: \#{task.name}"
          end

          tasks = [:one, :two]

          tasks.each do |name|
            task name do
              puts "execute: \#{name}"
            end
          end

          multitask :default => tasks do
            puts "execute: default"
          end
        RAKEFILE

        assert_labelled_output_matches(
          {
            nil => [
              "before_fork: default",
              "after_fork: default",
              "execute: default"
            ],
            "one" => [
              "after_fork: one",
              "execute: one"
            ],
            "two" => [
              "after_fork: two",
              "execute: two"
            ]
          },
          output
        )
      end
    end
  end
end
