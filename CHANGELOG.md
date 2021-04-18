# Changelog

This file tracks changes to the HIS-EMR-API-Lab module. Changes are categorised
as `Fixed`, `Added`, `Deprecated`, and `Removed`.
Versioning follows Semantic versioning which is documented [here](https://semver.org/spec/v2.0.0.html). 


## Unreleased

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