# frozen_string_literal: true

require "tempfile"
require "time"
$debug = File.open("/tmp/rake-multilogs-debug.log", "w");

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
        $debug.puts "#{Time.now.iso8601(6)} ##{Process.pid}: Created tempfile #{tempfile.path}"
        tempfile.close
        $debug.puts "#{Time.now.iso8601(6)} ##{Process.pid}: Closed tempfile #{tempfile.path}"


        lockfile = new(tempfile.path)

        begin
          yield lockfile
        ensure
          lockfile.close
          tempfile.unlink
          $debug.puts "#{Time.now.iso8601(6)} ##{Process.pid}: Unlinked tempfile #{tempfile.path}"
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
        $debug.puts "#{Time.now.iso8601(6)} ##{Process.pid}: Closed lockfile #{@path}"
      end

      # Acquires a lock, blocking until successful.
      #
      # @return [void]
      def lock
        @file ||= File.open(@path).tap { $debug.puts "#{Time.now.iso8601(6)} ##{Process.pid}: Opened lockfile #{@path}" }
        @file.flock File::LOCK_EX
        $debug.puts "#{Time.now.iso8601(6)} ##{Process.pid}: Locked lockfile #{@path}"
      end

      # Releases the acquired lock.
      #
      # @return [void]
      def unlock
        @file.flock File::LOCK_UN
        $debug.puts "#{Time.now.iso8601(6)} ##{Process.pid}: Unlocked lockfile #{@path}"
      end
    end
  end
end
