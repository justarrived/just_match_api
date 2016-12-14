# Production setup

## Deploy to Heroku

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/justarrived/just_match_api)

## Background task

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

__Cleanup__

Can be run more seldom, however once a day is recommended.

```
rails sweepers:cleanup
```

removes orphan and expired data.

__Frilans Finans__

Should run at least once an hour, but running more often (every 10 minutes) is recommended.

```
rails sweepers:frilans_finans
```

syncs relevant data with Frilans Finans.
