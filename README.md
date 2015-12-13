# JustArrived API (alpha) [![Build Status](https://travis-ci.org/buren/just_arrived.svg?branch=master)](https://travis-ci.org/buren/just_arrived) [![Code Climate](https://codeclimate.com/github/buren/just_arrived/badges/gpa.svg)](https://codeclimate.com/github/buren/just_arrived) [![Test Coverage](https://codeclimate.com/github/buren/just_arrived/badges/coverage.svg)](https://codeclimate.com/github/buren/just_arrived/coverage) [![Stories in Ready](https://badge.waffle.io/buren/just_arrived.png?label=ready&title=Ready)](https://waffle.io/buren/just_arrived) [![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/buren/just_arrived)

Welcome to the, very unofficial, API backend for Just Arrived. Everything in this
project is open source and licensed under the permissive [MIT](LICENSE.txt) license.

The API is designed to be consumed by multiple clients and the goal is that it should bevery easy to implement a client (Web/Android/iOS etc..).

The API tries to follow the [JsonApi 1.0](http://jsonapi.org/) standard, but is definetly not completely compliant yet. Please feel free to report any violations.

:warning: _Note_: The project it still in a very early stage and drastic changes to the API can be made at any time. If your thinking of doing a larger contribution please open an issue so it can be discussed (things can move real fast now in the beginning without much public discussion).

* [Getting started](#getting-started)
* [Tests](#tests)
* [Contributing](#contributing)

## Getting started

Setting the development environment is easy. If you don't have Ruby installed you can [follow this guide](https://github.com/rbenv/ruby-build).

```
$ git clone git@github.com:buren/just_arrived.git
$ cd just_arrived
$ bin/setup
$ foreman start
# Now you can open http://localhost:5000
```

You can also see the API documentation locally by going to `http://localhost:3000/api_docs`.

## Tests

This project uses `rspec` and you can find the tests `spec/`.

To run the test

```
$ bin/rspec
```

_Note_: Running the tests with `bundle exec rspec` will not work, please use `bin/rspec` instead.

## Deploy

The simplest way to deploy is with Heroku, you can get your own version running in a few minutes.

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/buren/just_arrived)

## Generate static docs

You can generate static versions of the API documentation in both `JSON` and `HTML` format.

Generate API doc
```
$ rake apipie:static_json
```

HTML
```
rake apipie:static
```

## Contributing

We would love if you'd like to help us build and improve this product for the
benefit of everyone. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org/) code of conduct.

Any contributions, feedback and suggestions are more than welcome.

If you want to contribute

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Tech

* Ruby 2.2
* Ruby on Rails 4.2.5
* PostgreSQL 9.3
* [JsonApi](http://jsonapi.org/) 1.0
