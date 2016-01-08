# JustMatch API (alpha) [![Build Status](https://travis-ci.org/justarrived/just_match_api.svg?branch=master)](https://travis-ci.org/justarrived/just_match_api)

[![Code Climate](https://codeclimate.com/github/justarrived/just_match_api/badges/gpa.svg)](https://codeclimate.com/github/justarrived/just_match_api) [![Test Coverage](https://codeclimate.com/github/justarrived/just_match_api/badges/coverage.svg)](https://codeclimate.com/github/justarrived/just_match_api/coverage)

Welcome to the official API backend for the Just Arrived matching service.

The API tries to follow the [JsonApi 1.0](http://jsonapi.org/) standard, but sill a long way from completely compliant. Please feel free to report any violations.

:warning: _Note_: The project is still in an early stage and drastic changes to the API can and will be made at any time. If your thinking of doing a larger contribution please open an issue so it can be discussed.

If you're looking for help or want to start contributing, want help, give feedback etc., you're more than welcome to join our Gitter chat.

[![Join the chat at https://gitter.im/justarrived/just_match_api](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/justarrived/just_match_api?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

* [Built with](#built-with)
* [Getting started](#getting-started)
* [Tests](#tests)
* [Docs](#docs)
* [Deploy](#deploy)
* [Commands](#commands)
* [Contributing](#contributing)
* [MIT License](#license)

## Built with

* Ruby 2.3
* Ruby on Rails 4.2
* PostgreSQL 9.3

## Getting started

_Prerequisites_: Ruby 2.3 and PostgreSQL

To setup your development environment

```
$ git clone git@github.com:justarrived/just_match_api.git
$ cd just_arrived
$ bin/setup
$ bin/server
# You can now open http://localhost:3000
```

If you navigate to `http://localhost:3000` you'll find the API documentation.

## Tests

This project uses `rspec` and you can find the tests in `spec/`.

You can run the test using

```
$ script/test
```

you can also run a single file or a single test:

```
# Run single file
$ script/test spec/models/user_spec.rb

# Run single test, on line 31, in file
$ script/test spec/models/user_spec.rb:31
```

_Note_: Running the tests with `bundle exec rspec` will not work, please use `script/test` instead.

## Docs

The API documentation is generated right were the code for that particular endpoint is.
That way the documentation is kept up to date.

__Development docs__

During development you can run find the documentation at `http://localhost:5000/`, as long as you have a started your server (you start it by running `script/server`).

__Static docs__

You can generate a static version of the API documentation with

```
$ script/doc
```

## Deploy

> __tl;dr let me deploy already__
>
> [![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/justarrived/just_match_api)


The simplest way to deploy is with Heroku, you can get your own version running in a few minutes.

You can also do it using the command line if you have the Heroku toobelt installed.

```
$ heroku create my-server-name
$ git push heroku master
$ heroku run rake db:migrate
```

## Commands

There are a few connivence commands

* `script/bootstrap` - installs/updates all dependencies
* `script/setup` - sets up a project to be used for the first time
* `script/update` - updates a project to run at its current version
* `script/server` - starts app
* `script/test` - runs tests
* `script/console` - opens a console

## Contributing

We would love if you'd like to help us build and improve this product for the
benefit of everyone. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org/) code of conduct.

Any contributions, feedback and suggestions are more than welcome.

If you want to contribute please take a moment to review our [contributing guide](CONTRIBUTING.md) in order to make the contribution process easy and effective for everyone involved.

If your not sure where to go you can always join our Gitter chat and ask :)

[![Join the chat at https://gitter.im/justarrived/just_match_api](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/justarrived/just_match_api?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

## License

This project is open source and licensed under the permissive [MIT](LICENSE.txt) license.
