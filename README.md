# Rake::Multilogs

Rake multitask logs can be confusing, with output from each of the concurrently-running tasks being interleaved.
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


## Usage

TODO: Write usage instructions here


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