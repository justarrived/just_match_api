# Docs - JustMatch API

Developer guide for JustMatch Api.

## High level

The code follows most Rails conventions. If you've worked with Rails before the project should be easy to navigate.

* __Technology__
  - Ruby 2.3
  - Ruby on Rails 5.0
  - PostgreSQL 9.3
  - Redis 3


* __Environment variables__
  + Used to configure app
  + [List of variables](environment-variables.md)


* __Uses `sidekiq` for background jobs (including emails)__


* __All role based access is contained in `app/policies`__
  - One for each controller
  - Uses the `pundit` gem


* __JSON serialization__
  - Uses the `active_model_serializers` gem
    + Uses the JSON API adapter
  - Follows the JSON API standard


* __Notifications and emails__
  - An `ActionMailer` like implementation for SMS has been implemented, see `JobTexter`
  - Every single notification/email has their on class in `app/notifiers`
    + Notifiers invokes the appropriate mailers and texters
  - Sends SMS messages using Twilio and the `twilio-ruby` gem

* __Invoices__
  - Integrates with Frilans Finans, using the local gem `frilans_finans_api`
  - All API communication to Frilans Finans is done from background jobs


* __File upload__
  - Uses the `paperclip` gem, together with `aws-sdk` to save files to AWS S3
  - All files are uploaded separately, then returns a token that is used for the actual resource that is connected to the file


* __Internal gems__
  - Some logic have been extracted to gems located in `lib/`, i.e
    + `JsonApiHelpers` "A set of helpers for generating JSON API compliant responses."
    + `FrilansFinansApi` "Interact with Frilans Finans API."
  - They aren't published separately because they aren't quite complete or ready for external use


* __Errors & Monitoring__
  - Uses the Airbrake and the `airbrake` gem for error notifications
  - Currently uses both `newrelic_rpm` and `skylight` gems, one will be picked later


* __API versions__
  - All routes namespaced under `api/v1/`
  - All controllers namespaced `Api::V1`


* __Admin tools__
  - Uses `activeadmin` gem
  - Admin interface under path `/admin`
  - Admin insights interface under path `/insights`
    + Uses the `blazer` gem


* __SQL queries/finders__
  - Located in `app/models/queries` namespaced under `Queries`


* __Documentation__
  - Uses the `apipie-rails` gem
  - API documentation is annotated just above each controller method
  - Can be generated with `script/doc`
  - The `Doxxer` class in `app/support` is for writing and reading API response examples


* __Tests__
  - Runners in `spec/spec_support/runners` are used to run extra checks when running tests
    + Runs only when running the entire test suite or if explicitly set
    + Some of them can halt the execution and return a non-zero exit status.
  - Test helpers are located in `spec/spec_support`
  - Uses `rspec`
  - Uses `webmock`
  - Geocode mocks in `spec/spec_support/geocoder_support.rb`


* __Translations__
  - Uses [Transifex](https://www.transifex.com/justarrived/justmatch-api/) to translate.
    + Configuration in `.tx/config`
    + Push/pull translations with [Transifex CLI](http://docs.transifex.com/client/)
