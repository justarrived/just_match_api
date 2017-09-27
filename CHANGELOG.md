# JustMatch API - Change Log

HEAD
-----------


v2.30 - 2017-09-27
----------
__API__:

* Explicitly set locale for each 3rd party job board feed
* Return job full standalone description instead of only the description to 3rd party integrations

__DB__:

* Add Company#staffing_agency boolean field
* Add Job#staffing_company belongs_to relation
* Add Order#previous_order_id field

__Enhancement__:

* Replace Job#company_job => Job#staffing_company
* Add JobEmployer model (not DB backed) and refactor job wrappers
* Add new order value change category type: extension
* Add Order#previous_order belongs to
* Update metrojobb wrapper to account for a badly named attribute name in the metrojobb API
* Return simple HTML to Arbetsförmedlingen rather than markdown..
* :hocho: type Bemaning => Bemanning
* Implemented the my unfilled jobs that expire in 10 days dashboard

__Admin__:

* Add Company#staffing_agency support
* Include jobs translations and language in order index page
* Add order extension support to index/show/form/filter sections
* Copy relevant attributes instead of cloning
* Copy previous order value to new extension order
* Add create order extension action button
* Improve Arbetsförmedlingen ad page performance
* Set locale explicitly when pushing Arbetsförmedlingen ads
* Update admin hint for job attributes
* Limit filter scope for Job#staffing_company

__Gem update__:

* Bump active_admin_scoped_collection_actions from 59ca05 to 04cdcb
* Bump airbrake from 6.2.1 to 7.0.0
* Bump lograge from 0.6.0 to 0.7.1
* Update nokogiri 1.8.0 => 1.8.1


v2.29 - 2017-09-21
----------
__Admin__:
* Update admin dashboard


v2.28 - 2017-09-21
----------
__API__:
* Return job description as HTML in metrojobb partner feed
* Fix BlocketjobbSerializer spec for blocketjobb body as HTML
* Add opportunities to metrojobb feed & return job description as HTML

__Enhancement__:
* Visible jobs should not be cancelled
* Unfilled jobs starting within 10 days dashboard

__Gem update__:
* Update metrojobb


v2.27 - 2017-09-19
----------
__Feature__:
* Metrojobb feed
  - API: Add `/partner-feeds/jobs/metrojobs` endpoint

__Admin__:
* Filter order users on order and not on job request
* Move job city input to be below the zip

__Enhancement__:
* Add `DateFormatter#yyyy_mm_dd` method
* Explicitly allow blank for some order value attributes
* Include Subscriber uuid instead of id in job digest mailer
* On invoice create make sure that the job is not cancelled
* Return HTML in `Blocketjobb::JobWrapper.body` instead of markdown

__Bugfix__:
* Update `OrderValue::CATEGORIES` and remove duplicate enum value

__Gem updates__
* Bump rubocop from 0.49.1 to 0.50.0
* Bump twilio-ruby from 5.2.2 to 5.2.3


v2.26 - 2017-09-15
----------
__Admin__:
* Add OrderValue validation on sold_number_of_months being 6 or less
* Only display Order#total_sold in order form if order is a direct recruitment


v2.25 - 2017-09-15
----------
__Admin__:
* Only display Order#total_sold in order form if order is a direct recruitment


v2.24.1 - 2017-09-15
----------
__Bugfix__:
* Return existing digest subscriber with the same email as a user if passed the same email


v2.24 - 2017-09-15
----------
__Enhancement__:
* Update subscriptions frontend route
* Update sv locale
* Replace `JobDigest#address` belongs to relation with has_many relation


v2.23 - 2017-09-14
----------
__API__:
* Make sure to return 404 in digest subscriber if no subscriber is found
* Return empty job digest list when no subscriber is found
* Add occupations to job digest allowed includes
* Find subscriber by uuid or user id in job digests controller

__Admin__:
* :hocho: N+1 query for user locale for some extra :rocket:
* Rename job digest subscriber relation
* Add Occupation DB production seed

__Update gem__:
* Bump `apipie-rails` from 0.5.3 to 0.5.4
* Bump `twilio-ruby` from 5.2.1 to 5.2.2
* Bump `kramdown` from 1.14.0 to 1.15.0

__Doc__:
* Update API doc examples


v2.22 - 2017-09-08
----------
__Enhancement__:
- Pull transifex translations
- Add `Job#invoice_comment` column

__Gem update__:

- rails 5.1.3 => 5.1.4
- apipie-rails
- bootsnap


v2.21 - 2017-09-08
----------
__Admin__:
 - Add passed scope to user previously performed jobs table

 __Enhancement__:
 - HTML email enhancements


v2.20 - 2017-09-08
----------
 __Admin__:
- Display previously performed jobs for user in user view & job user view
- Improved totals in orders sidebar showing revenue totals

__Enhancement__:
- Update `JobDigest` default max distance to 100km (from 50km)
- Validate `JobDigest#subscriber` relation


v2.19 - 2017-09-07
----------
__Admin__:

- Customize invoice CSV export


v2.18 - 2017-09-07
----------
* _API_:
  * `GET /api/v1/jobs/digests/notification-frequencies`
* _Enhancement_:
  * Update copyright notice in apipie configuration
  * Explicitly configure apipie to not use localization
  * Additional validations for OrderValue
  * Rename `serializeble_resource` => `serializable_resource`


v2.17 - 2017-09-06
----------
* _Enhancement_:
  - Check if value responds to empty? before testing it in Queries::Filter


v2.16 - 2017-09-05
----------
* _Feature_:
  - Job digests notifications
  - _New models_:
    + `Address`
    + `JobDigest`
    + `JobDigestOccupation`
    + `JobDigestSubscriber`
* _API_:
  - Add support for filtering occupations on their parents
  - Allow creation of DigestSubscriber in JobDigestSubscriber API
  - Proper implementation of /occupations
  - Implement OccupationSerializer
* _Admin_:
* _Enhancement_:
  - Update database import/restore tasks
  - Add `dev:db:heroku:import` Rake task
  - Make sure to handle `fake_attribute` type in `Queries::Filter`
  - Extract method from `Queries::Filter::filter` -> `::to_param_types`
  - Add `Queries::Filter#to_params` method
  - Remove redundant parameter to mailer action button
  - Extract UpdateUserService from UsersController
  - Enqueue job if user updates his/her email
  - Add JobDigestSubscriberSyncService that gets called in CreateUserService
* _Docs_:
  - Update API doc examples
  - Require geocoder stubs in docs env
  - Update doxxer models to document


v2.15 - 2017-09-05
----------
* _API_:
  - Calculate default customer invoice price when creating a job
  - Fallback on HTTP referrer request header if referrer is not set in JobUser POST body
* _Enhancement_:
  - Add `Job#customer_hourly_price` presence validation
  - Enforce `Company#swedish_municipality`
  - Decrease min `Company#street` length
* _Admin_:
  - Add stricter validation for JobRequest company relation/attributes
  - Update Company index dashboard


v2.14 - 2017-09-04
----------
* _Admin_:
  - Add stricter validation for `JobRequest` company relation/attributes
  - Update Company index dashboard
* _Enhancement_:
  - Enforce `Company#swedish_municipality`
  - Decrease min `Company#street` length


v2.13 - 2017-09-04
----------
* _Enhancement_:
  - Add env-config option for overriding the customer logo @ blocketjobb
  - Set default `JobOccupation#importance` in `SetJobOccupationsService`
* _Update gem:_
  - Bump byebug from 9.0.6 to 9.1.0
  - apipie-rails
  - rinku
  - twilio-ruby


v2.12 - 2017-08-29
----------
* _Bugfix_:
  - Fix issue where markdown links would be auto-linked before conversion to HTML
* _Enhancement_:
  - Explicitly require uri in `GoogleCalendarUrl`
  - Move `GoogleCalendarUrl` from `app/support` to `lib/`


v2.11 - 2017-08-26
----------
* _Admin_:
  - Added a job user relations sidebar and a job relations sidebar to job user view


v2.10 - 2017-08-23
----------
* _Bugfix_:
  - Make Order#job_request optional
* _Enhancement_:
  - Add Frilans Finans Invoice number to FrilansFinansInvoice model
  - Add EmailAddress#valid? method
* _Update gem_:
  - twilio-ruby
  - aws-sdk
  - puma
  - aws-sdk
* _Docs_:
  - Update PostgreSQL version in docs and README


v2.9 - 2017-08-17
----------
* _Admin_:
  - Display user presentation fields & minor admin SQL-query optimization :rocket:
  - Add Google Analytics to admin
* _Enhancement_:
  - Make `OrderValue#previous_order_value` relation optional
  - Fix Blazer linked columns address
* _Test_:
  - Fix FatoryGirl factories


v2.8 - 2017-08-16
----------
* _Bugfix_:
  - Explicitly set `User#language` as optional



v2.7 - 2017-08-16
----------
* _Bugfix_:
  - Add optional to Event#visit belongs, see https://github.com/ankane/ahoy/issues/276


v2.6 - 2017-08-16
----------
* _Feature_:
  * Create occupation & job occupation
* _DB_:
  - Create DB migration for missing foreign keys in orders and order_values
* _Update gem_:
  - active_admin_scoped_collection_actions
  - Use RubyGems version of blazer
* _Misc_:
  - :hocho: gem sidekiq-statistic
  - Gemfile cleanup


v2.5 - 2017-08-15
----------
* _Admin_:
  - Add company industries to views
  - Add job industries to views
* _Enhancement_:
  - Update i18n-tasks config & spec
  - Set all other applicants as rejected when a user signs for a job
  - Update SMSClient to be able to accept an instance of a client & update tests
  - :hocho: Sidekiq web. Closes #1199
  - Move responsibility from ApplicantWithdrawnNotification to SignJobUserService & ApplicantRejectedNotifier
* _Docs_:
  - Update JobUser create action API docs. Update API doc examples
- _Gem update_:
  - Update Rails => 5.1.3
  - rack-cords
  - redis-activesupport
  - twilio-ruby (4.1 => 5.1)
  - airbrake
  - aws-sdk
  - bootsnap
  - countries
  - faker
  - google-cloud-translate
  - httparty
  - i18n_data
  - lograge
  - better_errors
  - bullet
  - fog
  - i18n-tasks
  - rspec-rails


v2.4 - 2017-08-14
----------
* _API_:
  - Add job user tracking data support
* _Admin_:
  - Display tracking params on job user page
* _DB_:
  - Create migration for adding tracking params to `JobUser` model
    + `http_referrer`
    + `utm_source`
    + `utm_medium`
    + `utm_campaign`
    + `utm_term`
    + `utm_content`
* _Enhancement_:
  - Add github as a rubygems source in Gemfile
  - Proper non-blank check in `MessageUserService`. Closes #1197


v2.3 - 2017-08-08
----------
* _Bugfix_:
  - Proper non-blank check in `MessageUserService`. Closes [#1197](https://github.com/justarrived/just_match_api/issues/1197)


v2.2 - 2017-07-14
----------
* _Admin_:
  - :hocho: bad method name when creating a job from an order


v2.1 - 2017-07-14
----------
* _Admin_:
  - Remove new user form from company edit page


v2.0 - 2017-07-14
----------
* _Admin_:
  - Set user as managed if created from the companies form
  - Add form input hints to order form
  - Add Job#hidden to job data checklist sidebar
  - Add new user partial to company form and extract partial
  - Improve performance for orders
  - Improved display of order values KPIs
  - Display each order value in its own panel on order show page
  - Add list of validation errors to top of each custom form
  - Add global errors list to companies form
  - Extract show and form patials from order and add I18n
* _Feature_:
  - Implement OrderValue
* _Enhancement_:
  - Delete all bank account details when anonymizing the database for development use
  - Delete all tokens when anonymizing the database for development use
  - Add missing I18n keys to sv translation
  - Add Order#company field
  - Add additional params-keys to logging blacklist
  - Validate that order company mathes order job request company
  - Update README to include new instuctions on where to find the admin UI
  - Set top-level-domain length to zero so we can access the admin UI on http://admin.localhost:3000 See https://gist.github.com/indiesquidge/b836647f851179589765#solution
  - Do not convert Frilans Finans ID to integer


v1.118 - 2017-07-09
----------
- _Enhancement_:
  * Add `base_uri` config option to `ApacheTikaClient` and add `APACHE_TIKA_URL` to document parser
  * Rename `DocumentParserClient` => `ApacheTikaClient`
  * Update `script/deploy` to work better with different git-remotes


v1.117 - 2017-07-08
----------
* _Feature_:
  - Add `script/trackdeploy`
* _Enhancement_:
  - Add missing I18n field key to job user unrevertable error tests
  - Add missing I18n-key for HTTP Not Acceptable response
  - Add rack middleware that catches unknown formats
  - Add tests for `CatchJsonParseErrors`
  - Add tests for production seeds
  - Add SendMessageService#format_string exception comment and additional test
  - Rename `MessageUsersFromTemplate` => `MessageUsersFromTemplateService`
  - Rename `MessageUsers` => `MessageUsersService`
  - Rename `MessageUser` => `MessageUserService`
  - Refactor `MessageUser` to use `SendMessageService`
  - Create `SendMessageService`
  - Rescue `Redis::CannotConnectError` in `DeliverNotification`
  - Nil check email in `MessageUser#send_email`
  - Remove double nil check for user phone in `MessageUser#call`
  - Add additional test for BaseNotifier
* _Update gem_:
  - Rails 5.1.1 => 5.1.2
  - rspec_junit_formatter
  - timecop
  - airbrake
  - aws-sdk
  - ancestry
  - google-cloud-translate (0.23 => 1.0)


v1.116 - 2017-07-07
----------
* _Enhancement_:
  - Pull translations from Transifex
  - Update mail about salary
* _Update gem_:
  - `aws-sdk`
  - `kramdown`
  - `sidekiq`


v1.115 - 2017-07-04
----------
* _Admin_:
  - Improved job preview link
* _Enhancement_:
  - Pull translations from Transifex
  - Update salary info email copy


v1.114 - 2017-06-29
----------
* _Admin_:
  - Improved job preview link


v1.113 - 2017-06-29
----------
* _Admin_:
  - Add job preview link to sidebar if in preview mode
  - Set Comm.Template translation language on save
  - Limit Comm. template language form selection to only be system langs
* _Feature_:
  - Add support for job preview keys:
    + Only allow listing of job with preview key if the correct preview key is passed as a parameter
    + Add uniqueness validation on `Job#preview_key`
* _Enhancement_:
  * Remove unused allowed includes and optimize user-jobs endpoint
  * Add `job.company` and `job.company.company_images` to allowed includes. Closes #1182
  * Revert "Remove blocketjobb auth key, since they can't use it.."
  * Update `ApiPieDocHelper` to support fake attribute filter
  * Add support for `/jobs?filter[open_for_applications]=`. Closes #1178
  * Add `Job::open_for_applications` scope
  * Add `Job::closed_for_applications` scope
  * Implement `Job#published?` method


v1.112 - 2017-06-26
----------
* _Enhancement_:
  - Reimplement `DocumentParserClient` to directly interface with an Apache Tika web server
  - :hocho: Unused Struct


v1.111 - 2017-06-26
----------
* _Feature_:
  - _Document parsing_ - Add document content to `Document` model:
    + Add DocumentContentsAdderJob to user documents controller
    + Add ability to extract and add document content from file to our DB
    + Add Document#text_content DB column (text)
    + Add URL document to text function object
    + Add DocumentParserClient class
* _Admin_:
  - Add resumé search to users index page
  - Add job#last_application_at to job show page
* _Enhancement_:
  - Add Job::unfilled scope to blocketjobb and linkedin scopes
  - Decrease max markdown line width to fix regex range to big error
* _Update gem_:
  - bootsnap
  - aws-sdk
  - timecop


v1.110 - 2017-06-22
----------
* _Feature_:
  - Industry feature (new models: `Industry`, `IndustryTranslation`, `CompanyIndustry`, `JobIndustry`)
* _Admin_:
  - Add Company & Job industry undet the correct menu item
  - Industry implementation
* Add #has_ancestry to Industry model
* Add enum declaration to JobIndustry#importance
* _Add gem_:
  - `ancestry` (organize records in a tree structure)
* Add Industry and IndustryTranslation model
* _Enhancement_:
  - Add `job#publish_at` to job dev seed
  - Add missing sv translation
  - Pull translations from Transifex
  - Set markdown line width to a very large number (1 000 000). Closes #1169


v1.109 - 2017-06-20
----------
* _Update gem_:
  - arbetsformedlingen (and fetch it from RubyGems)


v1.108 - 2017-06-19
----------
* _Admin_:
  - When creating a job set the default #publish_at datetime to the current time
* _Update gem_:
  - airbrake
  - aws-sdk
  - pg
  - sidekiq


v1.107 - 2017-06-16
----------
* _Admin_:
  - Nest Feedbacks nav link under users
  - Nest CompanyTranslation under Misc nav-item
* _Bugfix_:
 - Specify max markdown line width. Closes #1169
 - Remote inline RTL styling from Google Translate result. Closes #1171


v1.106 - 2017-06-15
----------
* _Admin_:
  - Don't display rejected candidates in longlist
  - Improved order category form and filter


v1.105 - 2017-06-15
----------
* _Feature_:
  - Add user feedback model


v1.104 - 2017-06-15
----------
 * _Admin_:
  - Add job cancelled filter to job users view


v1.103 - 2017-06-15
----------
* _Enhancement_:
  - Add Frilans Finans Invoice id to job invoice specification


v1.102 - 2017-06-15
----------
* _Admin_:
  - Fix bug that caused an undefined method to be called on hash when saving an order without any order documents
  - Add job order link


v1.101 - 2017-06-14
----------
* _Admin_:
  - :hocho: :bug: Fix upload of order documents
* _Enhancement_:
  - Replace deprecated error class with new class constant


v1.100 - 2017-06-12
----------
* _Admin_:
  - Whitelist permitted params for CompanyTranslations
  - Include machine translations actions module in company resource
  - Protect against nil-cases in admin order


v1.99 - 2017-06-12
----------
* _Enhancement_:
  - Add new job description fields to JobTranslation
  - Use full standalone job description when pushing to Arbetsförmedlingen
  - Add `Job#full_standalone_description` that concatenates all description fields
  - Add `Markdowner::html_to_text` method
  - Add `I18n` for full description titles


v1.98 - 2017-06-12
----------
* _DB_:
  - Add `ArbetsformedlingenAd#occupation` (string)
* _Enhancement_:
  - Add support for Arbetsförmedlingen occupation


v1.97 - 2017-06-12
----------
* _API_:
  - Add `Company#short_description` to company serializer
  - Add new job description fields to jobs serializer
  - Add responsible recruiter to jobs serializer
  - Expose Company `#description` and `#short_description`
  - Remove `Company#users`
* _Admin_:
  - Add support for new job description fields
* _DB_:
  - Add job fields (translated):
    + `tasks_description`
    + `applicant_description`
    + `requirements_description`
  - Add company description (translated):
    + `short_description`
    + `description`
* _Enhancement_:
  - Update API doc examples
  - Replace unnecessary inheritance with class method call for spec runners
  - Replace `has_one` with `belongs_to` in serializers (avoids loading the relation) :rocket:
  - Add `UserImage` `recruiter_profile` category
  - Add missing I18n keys
  - Add bootsnap gem to speed up Rails boot time :rocket:
  - Add factory girl stats helper
  - Regenerate API doc examples
  - Ignore coverage for some files
  - Add explicit version to each `ActiveRecord::Migration`
* _Add gem_:
  - `fast_xs` for a faster String#to_xs implementation :rocket:
* _Update gem_:
  - mail
  - aws-sdk
  - sidekiq 5
  - webmock 2.0 => 3.0


v1.96 - 2017-06-08
----------
* _Enhancement_:
  - Update `arbetsformedlingen` company information to always be Just Arrived Bemaninng AB


v1.95 - 2017-06-08
----------
* _Bugfix_:
  - Send a numeric ID as the `PacketID` to Arbetsförmedlingen


v1.94 - 2017-06-08
----------
* _Bugfix_:
  - Fix no method error in ArbetsformedlingenAdService


v1.93 - 2017-06-08
----------
* _FrilansFinansApi_:
  - Add support for fetching a single profession

v1.92 - 2017-06-08
----------
* _Admin_:
  - Convert `ActionController:Parameters` to `Hash` for backward compatibility


v1.91 - 2017-06-08
----------
* _Enhancement_:
  - **Upgrade Rails from 5.0.2 to 5.1.1** :tada:
  - Remove config file with deprecated setting
  - Validate `UserInterest#level` and `UserInterest#level_by_admin` range
  - rubocop v49 :lipstick:
  - Test: Fix config issue when running specs for json_api_helper from JustMatch
* _Update gems_:
  - Updates develoment and test group gems


v1.90 - 2017-06-07
----------
 * _Admin_:
  - Copy `JobRequest` name to `Order`
  - Add `JobRequest#display_name`


v1.89 - 2017-06-07
----------
* _API_:
  - Only return published jobs from jobs endpoint
* _Admin_:
  - Add missing locales to job data checklist
  - Add two job filters
* _DB_:
  - Add `Job#publish_at` (datetime)
  - Add `Job#unpublish_at` (datetime)
* _Enhancement_:
  - Update `Job::blocketjobb_jobs` and `Job::linkedin_jobs` scope
  - Update production log level from DEBUG => INFO
  - Move lograge config next to other logging config
  - Add `I18n` for new job validation
  - Add job validation when published to linkedin
  - Add `Job::published` scope
* _Update gem_:
  - lograge
  - puma
  - rails-i18n
  - aws-sdk


v1.88 - 2017-06-06
----------
* _Admin_:
  - Display job order value on jobs index page
  - Remove unused eager loading on jobs index


v1.87 - 2017-06-06
----------
* _Enhancement_:
  - Replace `#before_filter` with `#before_action` in active_admin config
  - Add missing I18n key for `UserDocument::CATEGORIES` enum
  - `Job::blocketjobb_jobs` scope only returns jobs with last application dates in the future
  - Remove blocketjobb auth key, since they can't use it..
  - Add User document personal letter category
  - Move all remaining serializers from `app/support` to `app/serializers`


v1.86 - 2017-06-02
----------
* _Admin_:
  - Don't assume that `user_documents_attributes` always exists in user params


v1.85 - 2017-06-01
----------
* _Admin_:
  - Fix `AdminHelper#job_user_current_status_badge` for `Paid` status


v1.84 - 2017-06-01
----------
* _API_:
  - Add job attributes: open_for_applications and starts_in_the_future
  - Add Job#last_application_at_in_words to jobs serializer
  - Add JobUser#application_status. Closes #1005
  - Return high priority skills in user missing traits
* _Admin_:
  - Add job user status colors. Closes #1092
  - Add Order#category to filter. Closes #1148
  - Add Skill#high_priority support
  - Add support for uploading user documents directly in the user form. Closes #1133
  - Add total unfilled and unlost revenue to order index sidebar
  - Add user id filter on user index page. Closes #1146
  - Fix admin comments route
  - Improved ongoing jobs
* _DB_: Add Skill#high_priority (boolean, default: false)
* _Enhancement_:
  - :hocho: all references to key_transform
  - :hocho: key transform HTTP header test
  - Add `#distance_of_time_in_words_from_now` available to all serializers
  - Add `DateFormatter` support class
  - Add `Job#dates_object` that returns an instance of `Jobs::Dates`
  - Add `Jobs::Dates` class that encapsulates a jobs date functionality
  - Add `Job#open_for_applications?` method
  - Auto-format code with rubocop :lipstick:
  - Extract a few env-variables from the User model
  - Improve the Heroku Database Backup import task


v1.83 - 2017-05-30
----------
* _API_:
  - Add `Job#full_time` to job serializer


v1.82 - 2017-05-30
----------
* _Update gems:_
  - `aws-sdk`
  - `airbrake`
  - `skylight`
  - `google-cloud-translate`


v1.81 - 2017-05-30
----------
* _Admin_:
  - Add comments link to job and users relation sidebar
  - Add Order name and category + fix broken download link
  - Be defensive for JobTranslation#description show view
  - Fix order show/form for new fields
* _Enhancement_:
  - Update frontend chat route
  - Require `html_sanitizer` in `Markdowner`


v1.80 - 2017-05-24
----------
* Chat messages N+1 queries


v1.79 - 2017-05-24
----------
* _API_:
  - Allow users to set User#public_profile
* _Admin_:
  - Add User#public_profile support to admin
  - Improve admin footer
* _DB_:
  - Add `User#public_profile` boolean (default: false)
* _Enhancement_:
  - Add .env to spring reboot file
  - Update Job#city and Job#street min length


v1.78 - 2017-05-23
----------
* _Admin_:
  - Add job data checklist sidebar
  - Format Job#description on show pages
* _Enhancement_:
  - Only send admin notifications to super admins


v1.77 - 2017-05-23
----------
* _Admin_:
  - Add Markdown editor to JobTranslation and match preview styling
  - Add git tag to footer
* _Enhancement_:
  - Add VERSION file that contains the git-tag
* _Update gem_:
  - aws-sdk
  - geocoder
  - skylight
  - airbrake

v1.76 - 2017-05-22
----------
* _Admin_:
  - Improve custom footer that displays Heroku release meta data


v1.75 - 2017-05-22
----------
* _Admin_:
  - Add custom footer that displays Heroku commit sha
  - Add `JobRequest#company` filter and set `JobRequest#company_name` automatically
* _Enhancement_:
  - Add arbetsformedlingen env-vars to app.json
  - Update AF Jobwrapper unpublish date
  - Update Welcome app Client options
  - Welcome app auth key
* _Update gem_:
  - arbetsformedlingen


v1.74 - 2017-05-21
----------
* _Admin_:
  - Don't automatically translate jobs after save
  - Add note stating that documents only can be uploaded to an order if its been saved


v1.73 - 2017-05-20
----------
* _Feature_:
  - Add markdown support to all translated fields
* _Bugfix_:
  - Correctly handle translation lookups with nil-locale


v1.72 - 2017-05-18
----------
* Update welcome app service to not touch `User#updated_at`


v1.71 - 2017-05-16
----------
* _Admin_:
  - Add `direct_recruitment_job`
  - Add `staffing_job`


v1.70 - 2017-05-16
----------
* _Admin_:
  - Sync or create admin batch action


v1.69 - 2017-05-16
----------
* _Admin_:
  - Add ability to create remote FF Invoice


v1.68 - 2017-05-15
----------
* _API_:
  - Add user_images to include list for performance :rocket:
  - Update users documents default sort order when included under user
* _Enhancement_:
  - Extract `Linkedin::JobWrapper` class from `LinkedinJobsSerializer`
  - Rename BlocketjobbJobPresenter => Blocketjobb::JobWrapper for consistency
  - Return Swedish by default for:
    + Arbetsformedlingen ads
    + Blocketjobb ads
    + LinkedIN ads
  - Add utm_content param to:
    + Arbetsformedlingen ad push
    + Blocketjobb feed
    + Linkedin feed
  - :hocho: Deprecation warning for requiring airbrake/sidekiq


v1.67 - 2017-05-15
----------
* _Enhancement_:
  - Upgrade to Ruby 2.4.1
  - Update `User::needs_welcome_app_update` scope to only check regular users
* _Update gems_:
  - `aws-sdk`
  - `ahoy`
  - `airbrake`


v1.66 - 2017-05-12
----------
* Pull translations for Transifex


v1.64 - 2017-05-12
----------
* _Feature_:
  - Move admin interface from `/admin` to `admin.` subdomain
  - Check if user has Welcome!
* _API_:
  - Add User welcome app fields
* _DB_:
  - Add `User#has_welcome_app_account` (boolean, default: false)
  - Add `User#welcome_app_last_checked_at` (datetime)
* _Enhancement_:
  - Extract `CreateUserService` from users controller (refactor create action)
  - Track error if an database error occurs on user creation
  - Update `Dev::UserSeed`


v1.63 - 2017-05-11
----------
* _Admin_:
  - :hocho: job form bug when creating new jobs
* _Enhancement_:
  - FrontendRouter bugfix where default params always was used


v1.62 - 2017-05-11
----------
* _Enhancement_:
  - Allow blank `Job#blocketjobb_category` values unless published to Blocketjobb

v1.61 - 2017-05-11
----------
* _Features_:
  - Implement Blocketjobb feed
  - Add UTM-tracking params to all outgoing URLs
* _Admin_:
  - Don't show create invoice btn in admin if invoice already is created
* _DB_:
  * Add `Job#publish_on_blocketjobb` boolean field (default: false)
  * Add `Job#publish_on_linkedin` migration
  * Add `Job#publish_to_linkedin` boolean field (default: false)
* _Enhancement_:
  - Add `UtmUrlBuilder` class and add UTM param support to `FrontendRouter`
  - Add `welcome_app` gem (local gem under lib/ folder)
* _Update gems_:
  - active_model_serializers
  - ahoy_matey
  - aws-sdk
  - lograge
  - inherited_resources
  - mail and skylight
  - nokogiri
  - mail (fixed Security advisory: https://github.com/mikel/mail/pull/1097)


v1.60 - 2017-05-04
----------
* _API_:
  - Raise the API request throttle limit from 100 request/10 seconds => 500 request/10 seconds
* _Enhancement_:
  - `welcome_app` gem
  - Add proper configure class for `JsonApiHelpers`
  - Proper configuration module for `FrilansFinansApi`
  - Destroy week old frilans finans api logs sweeper task
  - Remove FrilansFinansApi::reset_config method


v1.59 - 2017-05-02
----------
* _Feature_:
  - Add OrderDocument model
  - LinkedIN patner feed
  - Arbetsformedlingen sync
* _Remove_:
  - :hocho: /users/:id/frilans-finans endpoint
  - :hocho: deprecated attributes in Countries serializer
  - :hocho: deprecated attributes in user statuses serialzier
  - :hocho: deprecated bank account attributes for user
  - :hocho: deprecated email param in reset password controller
  - :hocho: deprecated email param in user sessions controller
  - :hocho: deprecated job user methods & actions
  - :hocho: deprecated user image & language_ids param
  - :hocho: deprecated user#language_id param
  - :hocho: Remove tests for :skull: code
  - :hocho: test failures
  - :hocho: test for dead code
  - :hocho: `User#profile_image_token=`
* _Enhancement_:
  - Add `ApplicationRecord#{after|before}` methods
  - Add `FrilansFinansApiLogSweeper` that delets old entries
  - Set max document size to 20MB
* Admin:
  - Add cancel and notify action button to job show page
  - Add create ArbetsformedlingenAd button to job show page
  - Add JobUser::not_pre_reported scope
  - Add push to Frilans Finans button to user show page
  - Simpler order document upload
  - Unaccent certain user & job fields
* _API_:
  - Add /partner-feeds/jobs/linkedin endpoint
  - Implement /partner-feeds/jobs/linkedin route
  - Support both JSON & XML in LinkedIn feed
* _Doc_:
  - Add API error doc example to change password. Closes #962
  - Regenerate API doc examples
* _DB_:
  - Enable `unaccent` PostgreSQL extension
* _Update gem_:
  - arbetsformedlingen


v1.58 - 2017-04-26
----------
* _Bugfix_:
  - Custom error messages are returned correctly from the API
* _Enhancement_:
  - Update `User#bank_account` validation
* _Gem updates_:
  - active_admin_scoped_collection_actions
  - skylight
  - active_admin_datetimepicker
  - aws-sdk
  - faraday
  - rainbow
  - money
  - fog-rackspace
* Add URL validator and validate that Company#website is a valid URL
* _Remove_:
  * :hocho: Promo code
  * Deprecated `User#account` method


v1.57 - 2017-04-21
----------
* _API_:
  - Only return actually missing languages for user missing traits
  - Add `Job#application_url` to job serializer
* _Enhancement_:
  - Add facebook validator & improve linkedin validator


v1.56 - 2017-04-21
----------
* _Admin_:
  - Order dashboard enhancements
  - Add `User#facebook_url` to user show page
* _Bugfix_:
  - Misspelled method name in will perform notifier


v1.55 - 2017-04-20
----------
* _API_:
  - Add /users/:id/missing-traits. Closes #1082
  - Add User#bank_account to user serializer
  - Add User#facebook_url to permitted params
  - Add User#facebook_url to user serializer
  - Remove deprecated resources (amount & job-users) in Job serializer
  - Remove redundant attributes from User language serializer. Closes #1008
* _Admin_:
  - Add `JobRequest#company_address` to form
  - Add `linkedin_url` to user show page
  - Fix user chat link on user show page
  - Improve job request & order dashboards
* _Feature_:
  - Implement `job *-- order -- job_request`, to track orders
* _Bugfix_:
  - Fix broken User bank account validation
* _Enhancement_:
  - Don't notify already rejected job users
  - Update min gem requirements in Gemfile
  - Validate UserSkill proficiency range
  - Refactor missing user traits
  - Add `User#linkedin_url`
  - Add `User#facebook_url`
  - Move `app/support/*_validators` to `app/validators/`
  - Create LinkedIN URL validator
* _Update gem_:
  - aws-sdk
  - apipie-rails
  - blazer
  - inherited_resources
  - development group gems
* _Docs_:
  - Regenerate API doc examples


v1.54 - 2017-04-18
----------
* _Admin_:
  - Only show find FF user button when it makes sense
  - Add ability to find and set a user @ FF from user show view
  - Add link to job user translation on job user show view
* _FrilansFinansApi_:
  - Allow filtering of users by email
* _Enhancement_:
  - Add SSYK to `FrilansFinansImporter`
* _DB_:
  - Add `Category#ssyk` column


v1.53 - 2017-04-16
----------
* _Admin_:
  - :hocho: styling bug for skill and tag badges.
  - Add confirmation popup to activate invoice action
  - Add Job#staffing_job & #direct_recruitment_job to jobs show page
  - Improve job application show view
  - Update comment index view
* _API_:
  - Add meta/deprecations-key to API responses that has depcrecations
  - Consolidate User `#account_clearing_number` & `#account_number` to `User#bank_account`
  - RESTful jobs controller create
* _FrilansFinansApi_:
  - Update Document#error_status? comment
  - Add filter support to query builder and refactor Client#taxes
  - Add support for filtering users based on email
  - Don't require passed block in Walker & return flat array of all fetched resources
* _Enhancement_:
  - Return float from `Rating::average_score`
  - Also seed `Job#short_description`
  - Filter some lib folder for coverage report
* _Update gem_:
  - `aws-sdk`
  - `uglifier`
  - `skylight`
  - `yagni_json_encoder`
  - `rubodop`
  - `uglifier`
* _Docs_:
  - Regenerate API doc examples


v1.52 - 2017-04-05
----------
* _API_:
  - Return `meta/type`, `meta/value`, `meta/contain` keys in error objects
  - Add user_interests and interests to allowed includes in users controller
  - :lock: Add user check for performed controller
* `Docs`:
  - Update API error object section
* `JsonApiHelpers`:
  * Add support for Rails 5 error details and add meta data to model error-objects
* _Test_:
  - Don't run 'Check DB Indicies' test runner in script/cibuild
  - Admin controller specs
* _Gem updates_:
  - `google-cloud-translate`
* _Misc_:
  - Update I18n

v1.51 - 2017-04-04
----------
* _API_:
  - Expose User#interests in User serializer and only return visible skills
  - Add `Language#name` to `/languages` sortable fields


v1.50 - 2017-04-04
----------
* _Security_:
  - :lock: Properly authorize job user actions
* _Feature_:
  - Force users to consent to terms of agreement when applying for a job
* _Admin_:
  - Fix job collection actions
* _API_:
  - Add hint to skills and languages in /missing-traits response
  - Move the terms consent requirement from application to signing
  - Add language relation to /languages endpoint
    + Add language relation to /users/images/categories endpoint
  - Add language relation to /users/statuses endpoint
  - Add language relation to /users/gender endpoint
  - Add language relation to /faqs endpoint
  - Add language relation to countries endpoint
* _Enhancement_:
  - Add `BaseController#current_language` and pass it to serializer scope
  - Add current_language to serializer scope and refactor
  - Add support for relations in `JsonApiHelpers` gem
  - Add missing I18n string to `sv.yml`
* _Test_:
  - Eager load in test configuration option, set to true in `script/cibuild`
* _Docs_:
  - Update /missing-traits API example
  - Add API HTTP status code


v1.49 - 2017-04-02
----------
* _Docs_:
  - Regenerate API doc examples
  - Add current_page & total_pages meta-keys to API examples
  - Update authorization methods section
* API:
  - Add `GET /jobs/:job_id/users/:user_id/job-user`
  - Allow defining the auth token as an URL-param `auth_token`


v1.48 - 2017-04-02
----------
* _Admin_:
  - Add support for activating a `FrilansFinansInvoice` (and creating an `Invoice`)
  - Update i18n
* _API_:
  - Add support for filtering skills & languages on multiple ids
  - Add support for returning all the missing traits for a user given a job
  - Refactor `/missing-traits` action by extracting a serializer
  - Set token expired instead of deleting it and don't automatically cleanup old tokens
  - Don't strip splitted attributes in `Queries::Filter`
  - Add support to `Queries::Filter` to filter on lists
  - Add `JobUser#language` to serializer
* _Docs_:
  - Add `include` & `fields` params to `POST`/`PATCH` actions
  - Add `jobs/:id/users/:id/missing-traits` API docs
  - Update `/missing-traits` API doc example
* _Update gems_:
  - `aws-sdk`
  - `uglifier`
  - `airbrake`, 5.* => 6.0
* Don't assume that controller is defined in custom Ahoy store
* Enhance Google Translate detection event tracking
* Async geocoding for Ahoy
* Disable spring in `script/cibuild` to make coverage reliable
* Refactor and test `CreateTranslationService`, `ProcessTranslationService`
* Refactor API base controller to use new `Analytics` class
* Add `Analytics` class to unify event tracking
* Track translation detection event
* _Bugfixes_:
  - Properly unescape HTML from Google Translate

v1.47 - 2017-03-30
----------
* _Admin_: Add latest 5 comments to job show page


v1.46 - 2017-03-30
----------
* _Admin_: Add `activeadmin` plugin `active_admin_filters_visibility` for per user sorting & hiding filters


v1.45 - 2017-03-30
----------
* _Admin_:
  - Add comment resource
  - Convert most job batch actions to `scoped_collection_action`
  - Add `activeadmin` plugin: `active_admin_scoped_collection_actions`
  - Add admin comments namespace
* Update frontend router user edit path


v1.44 - 2017-03-30
----------
* Admin:
  - Refactor and update dashboard
  - Language scopes :lipstick:
* Update gems: ahoy_matey aws-sdk sidekiq uglifier
* Update dev gems (includes new security fix for nokogiri)
* Add `AhoyEvenetSweeper` that can delete events older than X and add rake task
* Allow setting that regular users are allowed to create jobs from ENV-var
* Extract `JobMailer#new_applicant_job_info_email` to `JobUserMailer` and add missing job-languages to email


v1.43.1 - 2017-03-29
----------
* Reset translation attribute if blank in `CreateTranslationService`
* Don't crash if text passed to `GoogleTranslate::Query` is nil


v1.43 - 2017-03-29
----------
* Don't process translation if blank OR the written language is 'undetermined'
* Refactor DetectLanguage
* _Docs_:
  - Regenerate API doc examples
  - Update API docs for user create
* Validate presence of `Comment#body` on create
* Remove `PATCH jobs/:id/comments/:comment_id` action
* Drop `User#system_language_id` from User serializer
* Update syntax for setting side session secret
* Set `sidekiq` session secret and domain


v1.42.1 - 2017-03-27
----------
* Set the correct session cookie key for Sidekiq
* Remove `Comment#body` presence validation, since it does not really work with virtual attributes


v1.42 - 2017-03-27
----------
* _Admin_:
  - Remove redundant checks for translated models
  - Don't define constants in dynamic context
* _Translation backend upgrade_:
  - Add support for plain text newlines in Google Translate
  - Replace `MachineTranslationsJob` => `ProcessTranslationJob` and update docs
  - Add `DetectLanguage` module
    + Min confidence threshold for translation set to 50%
  - Rename `BaseNotifier#notify` => `#dispatch`


v1.41 - 2017-03-26
----------
* Add missing index to `User#system_language`


v1.40 - 2017-03-25
----------
* _API_: Backward compatible errors response for User#language
* Fix User#system_language validation
* Correctly handle nil values in EmailValidator
* Validate presence of User#system_language and remove #language presence validation
* Add User#system_language and refactor all uses of User#language => #system_language
* Add User#language to #system_language data migration. Update user validator. Backwards compatibility
* checkpoint


v1.39 - 2017-03-22
----------
* _Admin_:
  - Update `JobRequest` filter options
  - Scope `#language` to `system_languages` for `Job` & `User`


v1.38 - 2017-03-17
----------
* Add `cf_reqmote_ip` &  `cf_up_remote_contry_code` to track_request payload
* Docs: Update API docs examples


v1.37 - 2017-03-16
----------
* _Gem updates_:
  - `aws-sdk`
  - `puma`
  - `codeclimate-test-reporter`
  - `fog`
  - `simplecov`


v1.36 - 2017-03-15
----------
* Add verb to default tracking props and include error response on 422 response status. Closes #992


v1.35 - 2017-03-13
----------
* _API_: Expose JobLanguage & JobSkill
* _Admin_:
  - Admin: Add missing call to super in job admin update
  - Add support for setting job languages
  - :hocho: dead form hint
* _DB_: Generate missing foreign keys for ahoy DB tables
* Pretty emails
  - HTML emails
  - Improve HTML emails rtl direction support
  - Add cta button to job rejection email
  - Add action buttons to the most important emails
* Update gem
  - `pg` 0.19 => 0.20
  - Update `uglifier` gem
* Request analytics
  - Add ahoy gem, configuration and controller setup
  - Add automatic request tracking to each request
* _Bug_:
  - :hocho: Bug for blazer `user_id` smart variables
* Create `JobLanguage` model
* Pull translations from Transifex


v1.34 - 2017-03-12
----------
* Pull translations from Transifex
* Create custom email address validator
* _Admin_:
  - Add additional action buttons to job form
  - User form
  - Refactor `AdminHelper`
  - Add job skills badges
  - Improve chosen selects
* Add user fields
  - `presentation_profile`
  - `presentation_personality`
  - `presentation_availability`
* Add `JobSkill#proficiency_by_admin`
* Extract mailer default layout


v1.33 - 2017-03-12
----------
* Add missing skill section to application email body
* Add ability for admins to send "ask for information emails" connected to a job, from the job user admin view
* Add ask for info notifier & add missing skills list to new applicant info email


v1.32 - 2017-03-11
----------
* :hocho: test failure in jobs controller
* Update `JobSkill`s
* Extract email-suggestion to its own controller & better predictions from `EmailSuggestion`
* Set custom Mailchecker domains and TLDs


v1.31 - 2017-03-11
----------
* Add `skill_id` blazer smart column
* Add `dev:db:heroku_import` task
* Add `dev:anonymize_database` task
* Add database docs
* :hocho: users controller test failure
* Add `dev:anonymize_database` task
* Update `User#reset!`
* Gem updates
  - `aws-sdk`
  - `countries`
  - `puma`
  - `redis-activesupport`
  - `skylight`
  - `uglifier`
  - `active_model_serializers`


v1.30 - 2017-03-10
----------
* _Admin_:
  - Update job user batch action name
  - Add just_arrived_contact_user filter to jobs page
* Update `JobUser#current_status` to handle `#rejected`
* Add `JobUser#rejected` boolean field (default: false) & send early rejection emails
* Increase `JobUser` max confirmation time to 24 hours (from 18)


v1.29 - 2017-03-09
----------
 * _Admin_: Left join jobs instead of join to keep jobs that does not have any applicants


v1.28 - 2017-03-09
----------
* Ignore codecoverage of `app/admin/` files
* Rename `ebert.yml` => `.ebert.yml`
* Disable Ebert eslint & scss lint
* _API_: Return wrong old password under correct attribute name for change password controller
* _Admin_:
  - Remove actions from job user index page
  - :hocho: N+1 query on dashboard
  - Improve job & job user index pages
  - Improve job admin index listing with more relevant table columns


v1.27 - 2017-03-07
----------
* Additional Blazer configuration
* _Admin_:
  - Add primary language to user filters & add missing admin I18n keys
  - Remove duplicate entry from blazer config
  - Reverse order of chat messages on user show page


v1.26 - 2017-03-07
----------
* _Blazer_:
  - Add Linked & Smart columns
  - Set PostgreSQL timeout to 14 sec
* _Admin_:
  - Remove destroy action from user, job user and job resources
  - Panel header links hover, middle align table rows, custom status colors
  - Just Arrived menu logo
  - Add job user shortlist batch action. Closes #953
  - Custom border and status_tag color
  - Custom flash colors


v1.25 - 2017-03-06
----------
* _Admin_:
  - Set chosen-selects to 100% width
  - Add Job `staffing_job` & `direct_recruitment_job` job form
* New `activeadmin` theme using the gem `active_admin_theme`

v1.24 - 2017-03-05
----------
* Update `rails` from 5.0.1 => 5.0.2
* Update gems: `airbrake`, `aws-sdk` and `uglifier`

v1.23 - 2017-03-05
----------
* Extract `SignJobUserService` from `jobs/ConfirmationsController`
* Adds `Job#staffing_job` boolean (default: false) field
* Adds `Job#direct_recruitment_job` boolean (default: false) field
* Only create `FrilansFinansInvoice`s for jobs that has *not* `staffing_job` or `direct_recruitment_job` set to true
* _API_: Expose `Job#staffing_job` and `Job#direct_recruitment_job` to API and allow sort & filter
* Add Ebert config `ebert.yml`
* `Geocodable#by_near_address` => `#near_address` and add `#near_coordinates` method
* _Admin_:
  - Add shortlisted scope and more informative city column
  - Replace Job#featured with #city on index page
  - Link to users with skills/tags from their respective index page. Closes #939
* _API_:
  - Add `#body_html` variant for comment & message serializers
  - Add `Job#decription_html` to allowed attributes
  - Add `User#support_chat_activated` feature toggle
  - Allow a user that has withdrawn the job application to re-apply
  - Don't delete job user, set `#application_withdrawn` instead
  - Extract create job application service and allow passing user_id as POST param
* _DB_:
  - Add JobUser#application_withdrawn column (default: false)
  - Add JobUser#shortlisted. Admin: JobUser show/index update
* _Docs_:
  - Regenerate API response examples
* :hocho: dead Rails config option
* Pull translations from Transifex
* Add `lograge` gem for a less verbose production log


v1.22 - 2017-03-03
----------
* Increase request limit to allow 100 requests per 10 seconds


v1.21 - 2017-03-02
----------
* _API_:
  - Update change password error responses
  - Temporary don't require consent when creating a new user
* Fix test failure for create Frilans Finans invoice
* Update `Geocodable` to ignore char casing on search and increase default search range to 50km (from 20km)
* Update the users `profession_title` @ Frilans Finans when creating an invoice


v1.20 - 2017-02-25
----------
* _API_: Remove `Job::unarchived` scope and remove from `Job::visible` scope


v1.19 - 2017-02-24
----------
* _Admin_:
  - Added sales and delivery user to permitted params in job request form


v1.18 - 2017-02-23
----------
* _Admin_:
  - Display large image on UserImage page
  - Display large image on CompanyImage page


v1.17 - 2017-02-23
----------
* Update gems: `aws-sdk` and `codeclimate-test-reporter`
* Generate migration for missing user keys for JobRequest
* Add sales and delivery use to job request permitted params


v1.16 - 2017-02-22
----------
* Add `JobRequest#sales_user` and `JobRequest#delivery_user` columns
* Update user admin seed
* _Admin_: Sort chat index by updated_at. Closes #912
* Update gems:
  - `aws-sdk` gem
* Update dev gems: `consistency_fail`, `dotenv-rails`, `i18n-tasks`, `immigrant` and `simplecov`


v1.15 - 2017-02-21
----------
_API_: Rename `HourlyPay#*_with_currency` => `*_with_unit`


v1.14 - 2017-02-21
----------
* _API_: Change `*_formatted` keys => `*_with_currency` & add `*_delimited` to job & hourly pay numbers


v1.13 - 2017-02-21
----------
* _API_: Add `Job::unarchived` scope and include the scope under `Job::visible`
* _Admin_: Accept and notify job users batch action

v1.12 - 2017-02-21
----------
* _Admin_:
  - Move job show view to its own template
  - Update document dashboard filters
* `Job#city` column:
  - Expose in API
  - Add to admin
* _FrilansFinansApi_:
  - Update links & meta parsing
  - Update meta-keys for all index fixtures

v1.11 - 2017-02-21
----------
* Don't validate `User#arrived_at` for blank strings
* Update `puma` gem 3.6 => 3.7


v1.10 - 2017-02-20
----------
* _Admin_:
  - Dashboard filter item order
  - Distinct job search
  - Add user & job name search to job user dashboard
  - Add hired users to job show page sidebar
  - Add link to job on job user show page
  - Add messaging batch actions to job users view
  - Move a few user sidebars to their own template files
  - Move user form implementation to its own file
  - Extract template locales from user show
  - Move user show implementation to its own file
  - Custom job form
* Depend on GitHub ankane/blazer for `blazer` gem
* Add `active_admin_datetimepicker` gem for nice datetime picker UI in admin


v1.9 - 2017-02-19
----------
* _Admin_:
  - Slim down dashboard filter options for:
    + user documents
    + user image
    + user language
    + user tag
  - Remove user filter and limit job filter to latest 200 jobs


v1.8 - 2017-02-19
----------
* Docs:
  - Update user images categories action
  - Update countries index action
  - Update user error API response example
* Add support for additional doc types: .odt, .txt, .rtf and another .doc variant
* Wgtrm import of `User` -> `UserLanguage`, `UserInterest`, `UserTag`, `UserDocument`:
  - Import users from CSV with find-or-create strategy
    + Phone
    + Email
    + Country of origin
    + Name
    + Residence (city)
    + Interests
    + Languages (with proficiency)
    + Tags
    + Resumes
* Update gems: `apipie-rails`, `aws-sdk` and `countries`
* Decrease minimum `User#first_name` length from `2` to `1`
* _Admin_:
  - Improved `UserLanguage` index view
  - Add user documents side bar to job user & user show+edit views


v1.7.1 - 2017-02-17
----------
* _FrilansFinansApi_: Add `FrilansFinansApi::User::index` method


v1.7 - 2017-02-17
----------
* _API_: Only return visible user languages and user skills
* `ValueFormatter` => `StringFormatter`. Add `NumberFormatter` and return prettified numbers in Hourly Pay & Job endpoints


v1.6 - 2017-02-16
----------
* _API_: Force UTF-8 encoding and replace invalid character
* _Admin_: Add missing admin I18n string
* Just return if no token found in authenticate method
* Don't raise `NoSuchTokenError` on existing, but wrong, token since that doesn't allow a user with an existing token to login again
* Add User & job HTML text field to users serializer
* Remove duplicated method from `AppConfig`
* _Admin_: Discard job user rejected view


v1.5 - 2017-02-15
-----------
 * _Frilans Finans_: Update user notification language value format
 * Normalize user fields before validation
 * Don't force SSL on the app level (we're doing it through other means..)
 * Don't translate `CommunicationTemplates` automatically
 * _API_: Return custom error message if token provided but not found


v1.4 - 2017-02-14
-----------
* Fallback on original translation if nothing better is found
* _API_: `/users/genders` endpoint
* _Admin_:
  + Replace bad template prefix
  + Fix nil pointer in `FrilansFinansLog` show page
  + Add `User#gender` to show page & filter
* Frilans Finans API V2
  + Frilans Finans API v2 compatibility
  + Send `remote_id` as a string to Frilans Finans API
  + Don't update `User#profession_title` @ FF API.
  + :lipstick: and :hocho: dead test file
  + Refactor `SyncFrilansFinansUserService` :lipstick:
  + Don't sync with Frilans Finans API unless configured to be active
  + _Admin_: Add ability to send employment certificate via Frilans Finans to user
  + Move FF invoice remote id from job id => FF invoice id
  + FrilansFinansApi: Implement EmploymentCertificate request
  + Grab Frilans Finans company resouce creator id from environment config
  + Update Frilans Finans API fixtures
  + Remove redundant user account sync code
  + Refactor FF controller to use Sync FF job
  + Wrap attributes in data.attributes
  + Update page query param name
- _Update gems_:
  + `airbrake`
  + `aws-sdk`
  + `blazer`
  + `geocoder`
  + `rails-i18n`
  + `kaminari`
  + `activeadmin`
  + `inherited_resources`

v1.3 - 2017-02-14
-----------
- `User#gender`
  - Add to permitted params & expose in API
  - Add User#gender field to DB
- :hocho: test failures for user interests/languages/skills controller
- _Admin_: Improved translations & machine translations

v1.2 - 2017-02-11
-----------
- Allow deletion of user traits unless an admin has touched them
- Scope user skills/interests/languages to the ones with a value set by the user
- Only return user interests with level
- Only return user languages with proficiency
- Only return user skills with proficiency
- Update Language#name_for to check not only for nil but blank?
- _API_: Sort languages on name
- `Language#name_for` locale fallback


v1.1 - 2017-02-09
-----------
- Update frontend routes
- Don't crash if job can't be updated in confirmations controller
- Update contact mailer recipient
- _Admin_:
  + Update nav+menu
  + Remove Frilans Finans from menu navigation
  + Enqueue translations on job save
  + Re-structure admin menu navigation


v1.0 - 2017-02-08 :tada:
-----------
- Filter
  + Admin
  + Query model `Queries::UserTraits`
  + Adds models
    * `Filter`
    * `FilterUser`
    * `LanguageFilter`
    * `SkillFilter`
    * `InterestFilter`
- Revamped emails
- Validate job owner belongs to company
- Update gems: rack-cors, puma, geocoder, faker, aws-sdk and airbrake
- Add gem: sidekiq-statistic

v0.28 - 2017-02-03
-----------
- _Admin_:
  + Update CommunicationTemplate index & show view
  + Add clone action button to job request
  + :hocho: crash when creating a new user from admin
- _Docs_: Add user password to API docs

v0.27 - 2017-02-02
-----------
- _Admin_: Restrict certain dashboards to super admins
- Add `User#just_arrived_staffing` field
- Add `User#super_admin` field
- Fixed bug where certain document content types were not allowed
- Narrow `User::needs_frilans_finans_id` query to only include users with a phone number (since thats required to create a user in Frilans Finans system)

v0.26 - 2017-02-01
-----------
* _Admin_: Improve `Document` & `UserDocument` views
* _Hotfix_: Register docx MIME type

v0.25 - 2017-02-01
-----------
- _Feature_: Document upload
  + _API_:
    * `POST /api/v1/documents`
    * `POST /api/v1/user:/documents`
  + _Admin:_ Support for managing documents and user documents

v0.24 - 2017-01-31
-----------
- _Admin_: Support user & company image uploads

v0.23 - 2017-01-31
-----------
- _Admin_: Remove `User#company` filter from index view
  + Custom company show page
  + Revamp users filter
  + Add batch actions to JobRequest
  + Add JobRequest to nav and add comments to show page
  + Re-direct to index path on job request update

v0.22 - 2017-01-30
-----------
- Update min `Skill#name` length to 1
- Add `User#interviewed_by` & `User#interviewed_at`
- _Import_: Add `users_from_sheet.rb` data importer
- Make `User#phone` optional
- _Admin_: :hocho: N+1 SQL-queries for user skills & interests :rocket:
- Make sure to not override user set values for user: languages, skills & interests

v0.21 - 2017-01-29
-----------
- Add `Interest` & `UserInterest`
  + API
  + Admin
  + Docs
- _Admin_: Update user show view

v0.20 - 2017-01-27
-----------
- _Admin_: Update job request view
- _API_: Add `job_ended` attribute to job user endpoint

v0.19 - 2017-01-27
-----------
- _Admin_:
  + Allow any language to `User#user_languages` selection
  + Update job_user/user views & extract code to partials
  + Improve job user show view
  + Update user show view
  + Revamp job user index & show view
  + Update job user index view

v0.18 - 2017-01-26
-----------
- User city field added to
  + _DB_: `User#field`
  + API
  + Admin
  + Added optional support for city to `Geocodable` module
- Regenerate API doc examples

v0.17 - 2017-01-25
-----------
- `Admin:`
  + Pretty print FF log requests/responses
  + Add gross amount to job show view
  + Add Token#expires_at to permitted params
- _API_: Add support for filtering companies by name and including their users
- Update `MessageUser` from email to use the default support email

v0.16 - 2017-01-24
-----------
- Add `ReceivedEmail` & `ReceivedText` model
- Send mails from no-reply by default in user mailer
- Admin: Update chat edit view
- Admin: Update `message`/`chat` views
- Update support email
- Admin: Prettier datetimes
- Add support for receiving emails from Sendgrid
- Support incoming SMS from Twilio
- Admin: Send communication templates from admin
- Add language relation to `SkillTranslation` model
- Add `CommunicationTemplateTranslation` and `CommunicationTemplate` models

v0.15 - 2017-01-24
-----------
- Allow users to ignore `failed_to_activate_invoice` notifications


v0.14 - 2017-01-24
-----------
- _API_: :hocho: N+1 SQL-query for `/api/v1/jobs` when logged in as admin or company user
- _Admin:_ :hocho: N+1 SQL-queries for some dashboards
- _I18n_: Add missing strings for `UserImage::CATEGORIES` and `User::STATUSES`
- Upgrade `sidekiq` 4.2.8 => 4.2.9, which resolves the problems we've had with `Redis::ConnectionError`
- Additional `UserImage::CATEGORIES`
- Additional `User::STATUSES`
- Sync retry sending of notification if the connection to Redis is down
- _API_: Sync with Frilans Finans after user create/update

v0.13 - 2017-01-16
-----------
- Sync user to Frilans Finans on update & change
- Add max password length validation to user
- Revamp `JobRequest`


v0.12 - 2017-01-15
-----------
- Tweak Sidekiq concurrency config (will hopefully resolve the `Redis::ConnectionError`s we're getting)
- Revert :hocho: rack-timeout gem
- Only delete really (6 months) old tokens


v0.11 - 2017-01-15
-----------
- _API_: Add `#name` and `#translated_text` attributes to language serializer
- Set max password length to 50
- :hocho: rack-timeout gem
- Validate and normalize User bank account details
- _API_: Add `/users/images/categories` endpoint.
- _API_: Add Rack middleware for rendering JSON:API compliant responses for JSON parse errors
- _API_: Add multilingual filter support
- _API_: Add `/users/email-suggestion` endpoint
- Ruby 2.4
- Catch `Redis::ConnectionError` in notifiers

v0.10 - 2017-01-10
-----------
- _Admin_: Add Job company & Just Arrived contact
- _Admin_: Remove `User#frilans_finans_payment_details` from admin user form
- _API_: Add filter by language name support for all locales
- _API_: Allow setting skills on `PATCH /users/:id`
- _API_: Set reset password token expiry time to 2 hours
- _API_: Add `user_skills.skill` to allowed includes for users endpoint
- _API_: User status endpoint I18n
- _API_: Add country code filter for `GET /countries` endpoint
- _API_: Add `UserSkills` and `Skills` to user endpoint

v0.9 - 2017-01-09
-----------
- Update `UserSkill` proficiency range to be 1..5 instead of 1..7
- _Admin_: Admin: Add `User#managed` to user create form
- Add student_visa to `User::STATUSES`
- Remove `User#auth_token` from users endpoint
- _API_: :hocho: jobs index N+1 query for owner translations :rocket:
- _Admin_: Order language select by name in user form


v0.8 - 2017-01-08
-----------
- _Admin_: Add custom user form [PR #781](https://github.com/justarrived/just_match_api/pull/781)
  + Custom new/edit forms
  + Ability add/remove `has_many` relations (`UserSkill`, `UserLanguage`, `UserTags`)
- Add skill translation support [PR #780](https://github.com/justarrived/just_match_api/pull/780)
- Add `Skill#proficiency` and `Skill#proficiency_by_admin` support to admin and API [PR #779](https://github.com/justarrived/just_match_api/pull/779)
- Add `temporary_residence_work` to `User::STATUSES` (137f2f6)
- Add `work_permit` to `UserImage::CATEGORIES`

v0.7 - 2017-01-04
-----------
- _Admin_: Update user admin show view
  + Add profile image to user show view [PR #774](https://github.com/justarrived/just_match_api/pull/774)
  + Add user languages to user show view [PR #773](https://github.com/justarrived/just_match_api/pull/773)
  + Update order of user fields and panels
- _API_: JSONAPI compliant image upload / Don't upload images with using multipart [PR #771](https://github.com/justarrived/just_match_api/pull/771)
- _Feature_: Additional user fields
  + Add `User#interview_comment` field
  + Add `User#{next_of_kin_name|next_of_kin_phone}` fields
  + Add `User#arbetsformedlingen_registered_at` field
- _Bugfix_: Don't allow password updates for `PATCH /api/v1/users/:id`
- _API_: Add `User#account_clearing_number` and `User#account_number` to users response (502c53a)
- _Update_: Don't assume live Frilans Finans seed from Rails being in production mode (7531c90)

v0.6 - 2017-01-04
-----------
- _Admin_: Display user skills in admin interface and add `Skill#color` [PR #768](https://github.com/justarrived/just_match_api/pull/768)
- _Update_: Update `UserLanguage` proficiency range from 1..10 to 1..5
- _Endpoint_: Add `POST /api/v1/users/:user_id/images` endpoint [PR #766](https://github.com/justarrived/just_match_api/pull/766)

v0.5 - 2017-01-03
-----------
- _Admin_: Smarter user index view for company users scope
- _Feature_: Enhanced `UserSkill` [PR #764](https://github.com/justarrived/just_match_api/pull/764)
  + Add `proficiency` and `proficiency_by_admin` fields
  + Searchable from admin user index view
- _Feature_: Adds support for `User ---* Tags` [PR #759](https://github.com/justarrived/just_match_api/pull/759)

v0.4 - 2016-12-30
------------
- _Notification_: Email notification on new job comment sent to job owner
- _Configuration_: Globally ignored notifications from ENV [PR #754](https://github.com/justarrived/just_match_api/pull/754)
- _DEPRECATE_: Frilans Finans Controller
- :hocho: Kill N+1 query for `/api/v1/jobs/:id/users`
- Add `AppConfig` & `AppSecrets` class
- Add `AppEnv` class wrapper around ENV for easier testing of ENV vars
- _Admin_: Remove N+1 queries from job user view

v0.3 - 2016-12-22
------------
- _Background job_: Updates all job filled statuses, by checking if there is a confirmed user for the job.

v0.2 - 2016-12-21
------------
- `CreateFrilansFinansInvoiceService` now calls `Job#invoice_company_frilans_finans_id` correctly instead of calling the associations directly, causing a check on Frilans Finans id on the wrong company.
- Added new admin user action for syncing bank account details to Frilans Finans.
- Display the category name in the admin interface, instead of just display the model name and id.
- Add user account_clearing_number and account_number to API docs for user create/update.

v0.1
-----------

..

hint `git log` is your friend
