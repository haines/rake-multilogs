# Rake::Multilogs

[![Docs](https://img.shields.io/badge/docs-github.io-blue.svg?style=flat-square)](https://haines.github.io/rake-multilogs/)
[![Gem](https://img.shields.io/gem/v/rake-multilogs.svg?style=flat-square)](https://rubygems.org/gems/rake-multilogs)
[![GitHub](https://img.shields.io/badge/github-haines%2Frake--multilogs-blue.svg?style=flat-square)](https://github.com/haines/rake-multilogs)
[![License](https://img.shields.io/github/license/haines/rake-multilogs.svg?style=flat-square)](https://github.com/haines/rake-multilogs/blob/master/LICENSE.md)
[![Travis](https://img.shields.io/travis/haines/rake-multilogs.svg?style=flat-square)](https://travis-ci.org/haines/rake-multilogs)


Rake [multitask](https://ruby.github.io/rake/Rake/DSL.html#method-i-multitask) logs can be confusing, with output from each of the concurrently-running tasks being interleaved.
`Rake::Multilogs` untangles the mess by capturing each task's output and displaying it after all the tasks are finished.


## Installation

Add this line to your application's Gemfile:

```ruby
gem "rake-multilogs"
```

And then execute:

```console
$ bundle install
```

Or install it yourself as:

```console
$ gem install rake-multilogs
```

JRuby and Windows are not supported, because  [`Process.fork`](https://ruby-doc.org/core/Process.html#method-c-fork) is unavailable.
`Rake::Multilogs` will gracefully fall back to the default (interleaved) output on those platforms.


## Usage

Add this line to your application's Rakefile:

```ruby
require "rake/multilogs"
```

Your multitasks will now run concurrently in forked processes, with each task's output displayed after all tasks have completed.

The use of forking rather than the default threading implementation means that database connections and other resources need to be handled carefully.
You need to make sure each forked process has its own connection by using the `before_fork` and `after_fork` hooks.

For example, with Active Record, you can put the following config in your Rakefile:

```ruby
Rake::Multilogs.before_fork do
  ActiveRecord::Base.connection.disconnect!
end

Rake::Multilogs.after_fork do
  ActiveRecord::Base.establish_connection
end
```


## Development

After checking out the repo, run `bin/setup` to install dependencies.
Then, run `bin/rake test` to run the tests.
You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bin/rake install`.
To release a new version, update the version number in `lib/rake/multilogs/version.rb`, and then run `bin/rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [RubyGems](https://rubygems.org).


## Contributing

Bug reports and pull requests are welcome [on GitHub](https://github.com/haines/rake-multilogs).
This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](CODE_OF_CONDUCT.md).


## License

© 2018 Andrew Haines, released under the [MIT license](LICENSE.md).
