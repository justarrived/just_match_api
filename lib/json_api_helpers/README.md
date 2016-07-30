# JsonApiHelpers

A set of helpers for generating JSON API compliant responses with together with the active_model_serializers gem.

:warning: This gem is by no means complete and currently is not fit for use outside of `just_match_api`.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'json_api_helpers'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install json_api_helpers

## Usage

```ruby
require 'json_api_helpers'

include JsonApiHelpers::Alias

JsonApiHelpers.deserializer_klass = ActiveModelSerializers::Deserialization
JsonApiHelpers.params_klass = ActionController::Parameters
JsonApiHelpers.default_key_transform = :dash # camel, camel_lower, underscore, unaltered

# Error
JsonApiError.new(status: 422, detail: 'too short', pointer: :first_name).to_h
# => {
#   :status => 422,
#   :detail => 'too short',
#   :source => {
#     :pointer => "/data/attributes/first-name"
#   }
# }
```

There are shorthands for all helpers that you can include:

```ruby
include JsonApiHelpers::Alias

JsonApiError
JsonApiErrors
JsonApiData
JsonApiDatum
JsonApiErrorSerializer
JsonApiSerializer
JsonApiDeserializer
JsonApiFilterParams
JsonApiSortParams
JsonApiFieldsParams
JsonApiIncludeParams
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Future

* Testing the `Serializer` class is currently not "possible" and the code in there is hard to follow and not very well extracted, this should be fixed :)
* Better dependency injection
* Test `JsonApiHelpers::Serializer` (currently those tests areas in the parent repos tests

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/justarrived/just_match_api/issues.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
