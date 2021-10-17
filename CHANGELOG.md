# Changelog

This file tracks changes to the HIS-EMR-API-Lab module. Changes are categorised
as `Fixed`, `Added`, `Deprecated`, and `Removed`.
Versioning follows Semantic versioning which is documented [here](https://semver.org/spec/v2.0.0.html). 


## Unreleased

## [v1.1.16] - 2021-10-18

### Fixed

- Hanging of OrderService#create_order and other methods when run outside of a rails request

## [v1.1.15] - 2021-10-14

### Fixed

- Orders not being pushed to LIMS immediately after creation

## [v1.1.14] - 2021-09-30

### Added

- Near realtime pushing of order updates to LIMS

## [v1.1.13] - 2021-09-06

### Fixed

- Crash in push_worker when pushing orders missing a target lab


## [v1.1.12] - 2021-08-24
## [v1.1.10] - 2021-08-23 - Yanked, was super buggy, superseded by the above

### Added

- Automatic voiding of duplicate orders

## [v1.1.9] - 2021-08-23

- Crash in LIMS worker on attempt to push duplicate order

## [v1.1.8] - 2021-08-20

### Fixed

- Duplicating of local orders when using rest_api

## [1.1.7] - 2021-08-09

### Fixed

- Crash in LIMS pull worker when pulling orders with specimen set null (normally when missig specimen is 'not_assigned')

## [1.1.6] - 2021-08-07

### Fixed

- Crash in LIMS pull worker when using rest_api

## [1.1.5] - 2021-07-21

### Fixed

- Crash on 401 error from LIMS in pull_worker

## [1.1.4] - 2021-07-21

### Added

- Fallback to unknown for missing phone numbers when pushing to LIMS
- Retry on error when pushing orders to LIMS

## [1.1.3] - 2021-07-19

### Added

- Configuration flag for setting the LIMS api to use for pushing/pulling of data

## [1.1.2] - 2021-07-15

### Added

- Pulling of updates for orders that are missing a reason for starting

### Fixed

- Slow query for pulling patient orders requiring updates

## [1.1.1] - 2021-07-12

### Fixed

- Crash in update patient orders background job (ArgumentError - Wrong number of arguments...)

## [1.1.0] - 2021-07-12

### Added

- Realtime results updates from LIMS
- LIMS REST API integration

## [1.0.5] - 2021-06-23

### Fixed

- Crash of umbrella Rails applications that mount this engine

## [1.0.4] - 2021-06-16

### Fixed

- Crash on pull of updates of locally voided orders

## [1.0.3] - 2021-06-10
### Fixed

- Result type detection in LIMS worker

## [1.0.2] - 2021-06-08

### Fixed

- Crash on attempt to Push anything that's not viral load to LIMS

## [1.0.1] - 2021-06-07

### Fixed

- Mapping of various names to LIMS (eg HIV Viral Load -> Viral Load and Medical Examination, routine to Routine)

## [1.0.0] - 2021-06-04

### Fixed

- Missing test status trail and orderer in LIMS DTO
- Disabled push to LIMS queue

## [0.0.15] - 2021-05-21
### Added

- LIMS data migration from MySQL database

## [0.0.14] - 2021-05-10

### Fixed

- Wrong provider name on order label

## [0.0.13] - 2021-05-01

### Added

- Workaround for partially voided patients in LIMS worker (in some sites there are patients
  that have everything voided besides the patient and patient identifiers entities - after
  merging)

## [0.0.12] - 2021-04-30
### Added

- Limiting number of LIMS migration workers through an environment variable: MIGRATION_WORKERS

## [0.0.11] - 2021-04-29

### Added

- Sample draw time to lab order label

## [0.0.9] - 2021-04-28

### Added

- Catch for orders without start date in LIMS worker

## [0.0.8] - 2021-04-27

### Fixed

- Order label: Added tests and shortened reason for test

## [0.0.7] - 2021-04-27

### Fixed

- Classifying of not_specified specimen_types as unknown specimen instead of not drawn in LIMS worker

### Added

- Search orders in a given date range

## [0.0.5] - 2021-04-21

### Fixed

- Grouping of numeric values with leading and trailing spaces as text in LIMS worker 

## [0.0.4] - 2021-04-20

### Added

- Wrapper for starting single instance of push/pull worker

### Fixed

- Various bug fixes for pull worker

## [0.0.3] - 2021-04-18

### Added

- Added LIMS data migration script
- Added LIMS push/pull worker

## [0.0.2] - 2021-04-07

### Fixed

- Setting order start_date to current date when retrospective date is specified

## [0.0.1] - 2021-03-27

### Added

- Entering of lab results
- Attaching specimen to lab orders
- Ordering of lab orders
- Listing test measures for each test type
- Listing of all known specimen types and test types
  * Each can be filtered by the other (ie you can filter specimen types by test types and vice versa)