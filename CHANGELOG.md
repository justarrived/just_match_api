# JustMatch API - Changelog

HEAD
-----------

- _Notification_: Email notification on new job comment sent to job owner
- _Configuration_: Globally ignored notifications from ENV [PR #754](https://github.com/justarrived/just_match_api/pull/754)
- _DEPRECATE_: Frilans Finans Controller
- :hocho: Kill N+1 query for /api/v1/jobs/:id/users
- Add `AppConfig` & `AppSecrets` class
- Add `AppEnv` class wrapper around ENV for easier testing of ENV vars
- _Admin_: Remove N+1 queries from job user view

v0.3
------------
- _Background job_: Updates all job filled statuses, by checking if there is a confirmed user for the job.

v0.2
------------
- `CreateFrilansFinansInvoiceService` now calls `Job#invoice_company_frilans_finans_id` correctly instead of calling the associations directly, causing a check on Frilans Finans id on the wrong company.
- Added new admin user action for syncing bank account details to Frilans Finans.
- Display the category name in the admin interface, instead of just display the model name and id.
- Add user account_clearing_number and account_number to API docs for user create/update.

v0.1
-----------

..

hint `git log` is your friend
