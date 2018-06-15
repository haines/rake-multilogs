# frozen_string_literal: true

module Rake
  module Multilogs
    # Labels to prepend to output lines for a set of tasks.
    class Labels
      include Enumerable

      # Creates a set of labels for the given tasks, which display the task name
      # in a column with a different color for each task. Up to 24 colors will
      # be used; if there are more than 24 tasks, the colors will repeat.
      #
      # @param tasks [Enumerable<Rake::Task>] tasks to generate labels for.
      def initialize(tasks)
        names = tasks.map(&:name)
        column_width = names.map(&:length).max + 1
        @labels = rainbow(names.size).zip(names).map { |color, name| "#{color}#{name.ljust(column_width)}|\e[0m " }
      end

      # @overload each(&block)
      #   Yields successive labels.
      #
      #   @yieldparam label [String] label to prepend to the output lines written by the corresponding task.
      #   @return [self]
      #
      # @overload each
      #   Creates an Enumerator that iterates over the labels.
      #
      #   @return [Enumerator<String>]
      def each(&block)
        @labels.each(&block)
      end

      private

      COLORS = [196, 166, 208, 214, 220, 184, 148, 112, 40, 41, 42, 43, 44, 38, 32, 33, 69, 135, 129, 128, 164, 163, 199, 198].freeze

      def rainbow(size)
        COLORS.values_at(*(0...COLORS.size).step(COLORS.size.to_f / size)).map { |value| "\e[38;5;#{value}m" }
      end
    end
  end
end
