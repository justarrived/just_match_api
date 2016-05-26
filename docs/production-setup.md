# Production setup

## Deploy to Heroku

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/justarrived/just_match_api)

## Background task

The API expects a few background tasks to be running, to clean up "orphan data" and integrate with the payment provider. The below tasks can easily bet setup using the Heroku Scheduling add-on.

The tasks are nested under the namespace `sweepers`.

__Overdue applications__

Should run at least once an hour, but running more often (every 10 minutes) is recommended.

```
rake sweepers:applicant_confirmation_overdue
```

updates all job applicants that haven't confirmed job owners acceptance in time.

__Cleanup__

Can be run more seldom, however once a day is recommended.

```
rake sweepers:cleanup
```

removes all orphan data.

__Frilans Finans__

Should run at least once an hour, but running more often (every 10 minutes) is recommended.

```
rake sweepers:frilans_finans
```

syncs relevant data with Frilans Finans.
