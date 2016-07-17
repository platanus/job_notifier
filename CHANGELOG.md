# Change Log
All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

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

* Initial release.
