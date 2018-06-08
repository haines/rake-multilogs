# frozen_string_literal: true

require "minitest/autorun"
require "open3"
require "rake/multilogs"

module Rake
  module Multilogs
    class Test < Minitest::Test
      def rake(rakefile)
        in_tmpdir {
          File.write "Rakefile", <<~RAKEFILE
            require "rake/multilogs"

            def snooze
              sleep rand(0.01..0.1)
            end

            #{rakefile}
          RAKEFILE

          Open3.capture2e("rake")
        }
      end

      private

      def in_tmpdir(&block)
        Dir.mktmpdir("rake-multilogs-test") { |dir| Dir.chdir(dir, &block) }
      end
    end
  end
end
