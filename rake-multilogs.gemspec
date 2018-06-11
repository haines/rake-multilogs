# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "rake/multilogs/version"

Gem::Specification.new do |spec|
  spec.name = "rake-multilogs"
  spec.version = Rake::Multilogs::VERSION
  spec.authors = ["Andrew Haines"]
  spec.email = ["andrew@haines.org.nz"]

  spec.summary = "Capture log output from Rake multitasks"
  spec.description = <<~DESCRIPTION
    Rake multitask logs can be confusing, with interleaved output from all parallel tasks.
    Rake::Multilogs untangles the mess by capturing each task's output and displaying it after all the tasks are finished.
  DESCRIPTION

  spec.homepage = "https://github.com/haines/rake-multilogs"
  spec.license = "MIT"

  spec.files = Dir.chdir(__dir__) { `git ls-files -z`.split("\x0").reject { |path| path.match(%r{^test/}) } }
  spec.require_paths = ["lib"]

  spec.metadata["yard.run"] = "yri"

  spec.add_dependency "rake", "~> 12.1"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "minitest", "~> 5.11"
  spec.add_development_dependency "pry", "~> 0.11"
  spec.add_development_dependency "rubocop", "~> 0.57.1"
  spec.add_development_dependency "yard", "~> 0.9"
  spec.add_development_dependency "yard-relative_markdown_links", "~> 0.1"
end
