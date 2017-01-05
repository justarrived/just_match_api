# JustMatch API - Changelog

HEAD
-----------

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
