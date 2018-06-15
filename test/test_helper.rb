# frozen_string_literal: true

require "minitest/autorun"
require "open3"
require "rake/multilogs"
require_relative "assert_labelled_output"

module Rake
  module Multilogs
    class Test < Minitest::Test
      include AssertLabelledOutput

      def rake(rakefile)
        in_tmpdir {
          File.write "Rakefile", <<~RAKEFILE
            require "rake/multilogs"

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
