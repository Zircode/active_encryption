# ActiveEncryption

ActiveEncryption transparently encrypt (and decrypt!) attributes. It works with any class, but it's primarly intended to be used with ActiveRecord models. Under the hood, it doesn't reinvent the wheel and uses the tried and tested ActiveSupport::MessageEncryptor.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'active_encryption'
```

And then execute:

```shell
bundle
```

Or install it yourself as:

```shell
gem install active_encryption
```

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake spec` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.
To release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push git
commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on
[GitHub](https://github.com/Zircode/active_encryption). This project is intended
to be a safe, welcoming space for collaboration, and contributors are expected
to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of
conduct.

## License

The gem is available as open source under the terms of the
[MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ActiveEncryption project’s codebases, issue trackers,
chat rooms and mailing lists is expected to follow the
[code of conduct](https://github.com/Zircode/active_encryption/blob/master/CODE_OF_CONDUCT.md).
