# frozen_string_literal: true

require "tempfile"

module Rake
  module Multilogs
    # An inter-process lock.
    class Lockfile
      # Opens a lockfile.
      #
      # @yieldparam lockfile [Lockfile] the opened lockfile
      # @return [void]
      def self.open
        tempfile = Tempfile.new("rake-multilogs-lock")
        tempfile.close

        lockfile = new(tempfile.path)

        begin
          yield lockfile
        ensure
          lockfile.close
          tempfile.unlink
        end
      end

      # @private
      def initialize(path)
        @path = path
      end

      # Closes the lockfile.
      #
      # @return [void]
      def close
        @file&.close
      end

      # Acquires a lock, blocking until successful.
      #
      # @return [void]
      def lock
        @file ||= File.open(@path)
        @file.flock File::LOCK_EX
      end

      # Releases the acquired lock.
      #
      # @return [void]
      def unlock
        @file.flock File::LOCK_UN
      end
    end
  end
end
