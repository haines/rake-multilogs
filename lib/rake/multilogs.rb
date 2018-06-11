# frozen_string_literal: true

require "rake"
require "rake/multilogs/fork"
require "rake/multilogs/forks"
require "rake/multilogs/task"
require "rake/multilogs/version"

module Rake
  # `Rake::Multilogs` groups multitask output by task, displaying it when all
  # tasks have completed, rather than the default behavior of displaying output
  # immediately (which means that output from different tasks becomes
  # confusingly interleaved).
  #
  # This requires `Process.fork`, so is not supported on JRuby or Windows.
  module Multilogs
  end
end

if Process.respond_to?(:fork)
  Rake::Task.prepend Rake::Multilogs::Task
else
  warn "Rake::Multilogs is disabled because Process.fork is not available on this platform"
end
