# Activestorage::Pinata

This gem extends the ActiveStorage::Service with an implementation for [Pinata](https://pinata.cloud)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'activestorage-pinata'
```

And then execute:

    $ bundle install

## Usage

In your Rails 5.2+ app, run:

```
rails active_storage:install
```

This will copy over active_storage migration for creating the tables and then run:

```
rails db:migrate
```
We now need to tell activestorage to use the Pinata IPFS service. Declare a Pinata service in `config/storage.yml`. Each service requires a `api_endpoint` and a `gateway_endpoint`

```yml
pinata:
  service: Pinata
  api_endpoint: https://api.pinata.cloud/pinning/pinFileToIPFS
  gateway_endpoint: https://gateway.pinata.cloud/ipfs/
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mul53/activestorage-pinata. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/activestorage-pinata/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Activestorage::Pinata project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/activestorage-pinata/blob/master/CODE_OF_CONDUCT.md).
