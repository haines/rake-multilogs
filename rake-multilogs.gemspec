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
    Rake multitask logs can be confusing, with output from each of the concurrently-running tasks being interleaved.
    Rake::Multilogs helps to untangle the mess by prefixing the logs with the name of the task that wrote each line (in glorious Technicolor).
  DESCRIPTION

  spec.homepage = "https://github.com/haines/rake-multilogs"
  spec.license = "MIT"

  spec.files = Dir.chdir(__dir__) { `git ls-files -z`.split("\x0").reject { |path| path.match(%r{^test/}) } }
  spec.require_paths = ["lib"]

  spec.metadata["yard.run"] = "yri"

  spec.add_dependency "rake", "~> 12.1"

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "diff-lcs", "~> 1.3"
  spec.add_development_dependency "minitest", "~> 5.11"
  spec.add_development_dependency "pry", "~> 0.12"
  spec.add_development_dependency "rubocop", "~> 0.74.0"
  spec.add_development_dependency "yard", "~> 0.9"
  spec.add_development_dependency "yard-relative_markdown_links", "~> 0.1"
end
