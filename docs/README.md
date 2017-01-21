# Docs - JustMatch API

Developer guide for JustMatch Api.

## High level

The code follows most Rails conventions. If you've worked with Rails before the project should be easy to navigate.

* __Technology__
  - Ruby 2.4
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
  - Almost all API communication with Frilans Finans is done from scheduled jobs

* __Geocoding__
  - Uses `geocoder`
  - All models that need geocoding abilities include the `Geocodable` module
  - Uses Google Maps under-the-hood


* __File upload__
  - Uses the `paperclip` gem, together with `aws-sdk` to save files to AWS S3
  - All files are uploaded separately, the API then returns a token, that then can be used when creating a new resource


* __Internal gems__
  - Some logic have been extracted to gems located in `lib/`, i.e
    + `JsonApiHelpers` "A set of helpers for generating JSON API compliant responses."
    + `FrilansFinansApi` "Interact with Frilans Finans API."
  - They aren't published separately because they aren't quite complete or ready for external use


* __Errors & Monitoring__
  - Uses the Airbrake and the `airbrake` gem for error notifications
  - Uses `skylight` gem for performance monitoring ([skylight.io](https://skylight.io))


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
  - Generate docs with `script/docs`
  - Uses the `apipie-rails` gem
  - API documentation is annotated just above each controller method
  - The `Doxxer` class in `app/support` is for writing and reading API response examples


* __Tests__
  - Uses `rspec`
  - Uses `factory_girl`
  - Runners in `spec/spec_support/runners` are used to run extra checks when running tests
    + Runs only when running the entire test suite or if explicitly set
    + Some of them can halt the execution and return a non-zero exit status.
  - Test helpers are located in `spec/spec_support`
  - Uses `webmock`
  - Geocode mocks in `spec/spec_support/geocoder_support.rb`

* __Model translation__
  - Each model that need translated columns
    + has a corresponding model, i.e `JobTranslation`
    + includes `Translatable` module
  - Translation model
    + includes `TranslationModel` module
  - Defines the translated columns with the `translates` macro
    + That macro will defines a `set_translation` instance method on the model
  - There are a few helper services, plus one `ActiveJob` class to do machine translations
    + `MachineTranslationsService` takes a translation and creates translations for to all eligible locales
    + `MachineTranslationService` takes a translation and a language for it to be translated to
    + `MachineTranslationsJob` background job for `MachineTranslationsService`
  - Uses Google Translate under the hood

* __Static Translations__
  - Uses `rails-i18n`
  - Stored in `config/locales/`
  - Supports fallbacks
  - Uses [Transifex](https://www.transifex.com/justarrived/justmatch-api/) to translate.
    + Configuration in `.tx/config`
    + Push/pull translations with [Transifex CLI](http://docs.transifex.com/client/)

* __Receiving SMS__
  - Configure a HTTP POST Hook in the Twilio Console
    + Add the route: `POST https://api.justarrived.se/api/v1/sms/receive?ja_KEY=$JA_KEY`, replace `$JA_KEY` with something secret.
  - The SMS from number will be looked up and if there is a match a message will be added to the chat between that user and our "support user" or admin.
