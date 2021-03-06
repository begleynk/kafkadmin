# Kafkadmin

A small web API to be run on Kafka brokers that provides administration commands, by allowing access to Kafka's own binaries.

The purpose of this API is to support some actions that are currently not available in many open source client libraries. Eventually, hopefully, it should become irrelevant.

*NOTE*
This is by no means production ready. This was a fun little side side side project that is not maintained.

## Installation

```ruby
gem 'kafkadmin'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install kafkadmin

## Running the server

To start up Kafkadmin

    $ kafkadmin start --help        # See all available options
    $ kafkadmin start [options]

If you want to run Kafkadmin as a daemon,

    $ kafkadmin start --daemon

To kill the daemonized server,

    $ kafkadmin stop

## Configuration

You can pass configuration options to Kafkadmin in two ways: via the command line when starting the server, or through a ~/.kafkadmin YAML file. The CLI options will override your ~/.kafkadmin options.

### Example ~/.kafkadmin

    daemon: false
    kafka_path: /opt/kafka
    log_dir: /var/log/kafkadmin
    zookeeper_string: "192.168.35.10:2181"

## Supported Actions

### Create a topic

    POST /topics
    {
      "name": "foo",
      "partitions" 5,
      "replication_factor": 1
    }

### Delete a topic

    DELETE /topics/*topic_name*

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bundle exec rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/begleynk/kafkadmin. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

