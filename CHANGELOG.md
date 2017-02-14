# JustMatch API - Change Log

HEAD
-----------

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
