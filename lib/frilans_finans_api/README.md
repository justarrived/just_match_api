# FrilansFinansApi

Interact with Frilans Finans API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'frilans_finans_api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install frilans_finans_api

__Configure__

```ruby
FrilansFinansApi.client_klass  = FrilansFinansApi::Client
FrilansFinansApi.base_uri      = ENV.fetch('FRILANS_FINANS_BASE_URI')
FrilansFinansApi.client_id     = ENV.fetch('FRILANS_FINANS_CLIENT_ID')
FrilansFinansApi.client_secret = ENV.fetch('FRILANS_FINANS_CLIENT_SECRET')
```

## Usage

```ruby
include FrilansFinansApi

# GET /professions?page=1
document = Profession.index(page: 1)
document.resources.each do |profession|
  puts profession.attributes['title']
end
document.total_pages

# Iterate over all professions, page by page
Profession.walk(page: 1) do |document|
  document.resources.each do |profession|
    puts profession.attributes['title']
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/frilans_finans_api.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
