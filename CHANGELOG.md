# JustMatch API - Changelog

HEAD
-----------

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
