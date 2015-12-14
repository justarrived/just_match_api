# JustMatch API (alpha) [![Build Status](https://travis-ci.org/buren/just_arrived.svg?branch=master)](https://travis-ci.org/buren/just_arrived)

[![Code Climate](https://codeclimate.com/github/buren/just_arrived/badges/gpa.svg)](https://codeclimate.com/github/buren/just_arrived) [![Test Coverage](https://codeclimate.com/github/buren/just_arrived/badges/coverage.svg)](https://codeclimate.com/github/buren/just_arrived/coverage)

Welcome to the, very unofficial, API backend for Just Arriveds matching service.

The API is designed to be consumed by multiple clients and the goal is that it should easy to implement a client (Web/Android/iOS etc..).

The API tries to follow the [JsonApi 1.0](http://jsonapi.org/) standard, but sill a long way from completely compliant. Please feel free to report any violations.

:warning: _Note_: The project it still in a very early stage and drastic changes to the API can be made at any time. If your thinking of doing a larger contribution please open an issue so it can be discussed.

If you're looking for help or want to start contributing, want help, give feedback etc., you're more than welcome to join our Gitter chat:  [![Join the chat at https://gitter.im/buren/just_arrived](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/buren/just_arrived?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

* [Built with](#built-with)
* [Getting started](#getting-started)
* [Tests](#tests)
* [Deploy](#deploy)
* [Contributing](#contributing)
* [License](#license)

## Built with

* Ruby 2.2
* Ruby on Rails 4.2
* PostgreSQL 9.3

## Getting started

_Prerequisites_: Ruby 2.2, PostgreSQL

To setup your development environment

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


## Docs

The API documentation is generated right were the code for that particular endpoint is.
That way the documentation is kept up to date.

__Development docs__

During development you can run find the documentation at `http://localhost:5000/`.

__Static docs__

_Note_: Before generating the docs you must have migrated your database (`bin/rake db:migrate`).

You can generate static versions of the API documentation in both `JSON` and `HTML` format.

Generate API doc
```
$ bin/rake apipie:static_json
```

HTML
```
$ bin/rake apipie:static
```

## Deploy

> __tl;dr let me deploy already__
>
> [![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/buren/just_arrived)


The simplest way to deploy is with Heroku, you can get your own version running in a few minutes.

You can also do it using the command line if you have the Heroku toobelt installed.

```
$ heroku create my-server-name
$ git push heroku master
$ heroku run rake db:migrate
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

## License

This project is open source and licensed under the permissive [MIT](LICENSE.txt) license
