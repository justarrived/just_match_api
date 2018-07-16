# Production setup

## Deploy to Heroku

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/justarrived/just_match_api)

## Background tasks

The API expects a few background tasks to be running, to clean up "orphan data" and integrate with the payment provider. The below tasks can easily bet setup using the Heroku Scheduling add-on.

The tasks are nested under the namespace `sweepers`.

__Overdue applications__

Should run at least once an hour, but running more often (every 10 minutes) is recommended.

```
rails sweepers:applicant_confirmation_overdue
```

__Update `Job#filled` status__

Should run at least once an hour, but running more often (every 10 minutes) is recommended.

```
rails sweepers:update_job_filled_status
```

updates all job filled statuses, by checking if there is a confirmed user for the job.

__Anonymize users__

```
rails sweepers:anonymize_users
```

anonymize all users that are marked for anonymization or should be cleaned up because lack of activity, recommended to run at least once a week.

__Cleanup__

```
rails sweepers:cleanup
```

removes orphan and expired data, recommended to run at least once a week.

__Frilans Finans__

Should run at least once a day, but running more often, like every hour, is recommended.

```
rails sweepers:frilans_finans
```

syncs relevant data with Frilans Finans.
