# Change Log
All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

### Unreleased

##### Added

- Allow jobs without owner.

### v1.4.0

##### Changed

- Use update_attributes instead of update_columns to change update_at attribute.

### v1.3.0

##### Added

- Add silenced_log config option to disable silencer gem.

### v1.2.4

##### Fixed

- Check if /jobs endpoint returns response root.

### v1.2.3

##### Changed

- Avoid raising error with undefined verify_authenticity_token method.

### v1.2.2

##### Changed

- Rails dependency version more flexible.
- Colorize dependency version more flexible.

### v1.2.1

##### Changed

- Enumerize dependency version more flexible.

### v1.2.0

##### Added

- Add Hound configuration.
- Deploy with Travis CI.
- Configure coveralls.

### v1.1.1

#### Fixed

- Use silencer gem to ensure ActiveRecord's log is silenced too.

### v1.1.0

#### Added

- Replace Rails::Rack::Logger class with custom logger to avoid noisy logs.

### v1.0.0

#### Added

- Replace `GET /jobs` with `GET /:identifier/jobs/pending` and `PUT /:identifier/jobs/notify` to mark jobs as notified in a second step.

### v0.2.1

#### Fixed

- Avoid polling with nil jobIdentifier

### v0.2.0

#### Added

- job_class attribute in Job class to identify different jobs.

### v0.1.1

#### Fixed

- Call private include method using send.

### v0.1.0

- Initial release.
