# frozen_string_literal: true

module Rake
  module Multilogs
    # Pipes lines to an IO with a label prepended to each line.
    class Labeller
      # @param out [IO] IO to write output to.
      # @param label [String] label to prepend to each line written.
      # @param lockfile [Lockfile] lockfile to prevent multiple processes writing output simultaneously.
      def initialize(out:, label:, lockfile:)
        @out = out
        @label = label
        @lockfile = lockfile
      end

      # Opens the pipe.
      #
      # @return [IO] the write end of the pipe.
      def to_io
        @reader, @writer = IO.pipe
        @pid = fork { tee }
        @reader.close
        @writer
      end

      private

      def tee
        @writer.close

        while (line = @reader.gets)
          @lockfile.lock
          @out.print @label, line
          @lockfile.unlock
        end
      end
    end
  end
end
