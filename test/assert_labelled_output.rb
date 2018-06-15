# frozen_string_literal: true

require "diff-lcs"

module AssertLabelledOutput
  def assert_labelled_output_matches(expected, actual)
    diffs = Diffs.new(expected, actual)
    assert diffs.empty?, diffs.to_s
  end

  def assert_labelled_output_contains(expected, actual)
    diffs = Diffs.new(expected, actual)
    assert diffs.subset?, diffs.to_s
  end

  class Diffs
    def initialize(expected, actual)
      @expected = convert_expected(expected)
      @actual = convert_actual(actual)

      @diffs = (@expected.keys + @actual.keys).uniq.map { |label|
        Diff.new(
          @expected.fetch(label, []),
          @actual.fetch(label, [])
        )
      }.reject(&:empty?)
    end

    def empty?
      @diffs.empty?
    end

    def subset?
      @diffs.all?(&:subset?)
    end

    def to_s
      @diffs.join
    end

    private

    def convert_expected(values)
      values.map { |label, lines|
        [label, lines.map { |line| Line.new(label, line) }]
      }.to_h
    end

    def convert_actual(value)
      value.lines.map { |line| Line.new(*split(line)) }.group_by(&:label)
    end

    def split(line)
      /\A(?:(?<label>.*?) \|\e\[0m )?(?<line>.*)\n\z/.match(line).values_at(:label, :line)
    end
  end

  class Diff
    def initialize(expected, actual)
      @expected = expected
      @actual = actual
      @diff = ::Diff::LCS.diff(expected, actual, DiffCallbacks.new)
    end

    def empty?
      @expected == @actual
    end

    def subset?
      (@expected - @actual).empty?
    end

    def to_s
      @diff.map { |line| "#{line}\n" }.join
    end
  end

  class DiffCallbacks
    attr_reader :diffs

    def initialize
      @diffs = []
    end

    def finish; end

    def discard_a(event)
      @diffs << remove(event.old_element)
    end

    def discard_b(event)
      line = event.new_element
      if @diffs.last == remove(line)
        @diffs.pop
        @diffs << unchanged(line)
      else
        @diffs << add(line)
      end
    end

    def match(event)
      @diffs << unchanged(event.old_element)
    end

    private

    def unchanged(line)
      "  #{line}"
    end

    def add(line)
      "\e[33m+ #{line}\e[0m"
    end

    def remove(line)
      "\e[31m- #{line}\e[0m"
    end
  end

  class Line
    attr_reader :color, :label, :line

    def initialize(label, line)
      @line = line
      @label, @color = extract_color(label)
    end

    def ==(other)
      label == other.label && line == other.line
    end

    alias eql? ==

    def hash
      [label, line].hash
    end

    def to_s
      return line if label.nil?
      "#{label} | #{line}"
    end

    private

    def extract_color(label)
      /\A(?<color>\e\[38;5;\d+m)?(?<label>.*)\z/.match(label)&.values_at(:label, :color) || [label, nil]
    end
  end
end
