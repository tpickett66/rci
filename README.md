# RCI

(R)edis (C)lient (I)nstrumenter

Adds ActiveSpport::Notifications to calls made against redis using the official redis clients

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rci'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rci

## Usage

Since the instrumentation depends on being able to query the server for the commands
it supports you'll need to initialize everything with one of two methods:

```
redis = Redis.new

# Attach to every Redis client in the system (most apps will do this)
RCI.setup(redis)

# Attach to only a specific Redis client
RCI.attach_instrumentation_to(redis)
```

Both of these methods will call out to the Redis server to get a list of commands before
attaching the instrumentation.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/rci/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
