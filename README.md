![Ruby](https://github.com/EGPAFMalawiHIS/HIS-EMR-API-Lab/workflows/Ruby/badge.svg?branch=development)
# Lab

A Rails engine for [HIS-EMR-API](https://github.com/EGPAFMalawiHIS/HIS-EMR-API)
compatible applications that provides an API for managing various lab
activities.

## Usage

The engine provides an API that provides the following functionalities:

  - Search/Retrieve test types
  - Search/Retrieve sample types for a given test
  - Order lab tests
  - Attach a result to a test

For details on how to perform these operations please see the
[API docs](https://raw.githack.com/EGPAFMalawiHIS/HIS-EMR-API-Lab/development/docs/api.html).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'his_emr_api_lab', git: 'https://github.com/EGPAFMalawiHIS/HIS-EMR-API-Lab', branch: 'development'
```

And then execute:

```bash
$ bundle install 
```

Or install it yourself as:

```bash
$ gem install his_emr_api_lab
```

Finally run:

```bash
$ bundle exec rails his_emr_api_lab:install
```

## Configuration

This module in most cases should work without any configuration, however to enable
certain features some configuration may be required. Visit the
[configuration](./docs/configuration.md) page to learn how to configure the
application.

## Contributing

Fork this application create a branch for the contribution you want to make,
push your changes to the branch and then issue a pull request. You may want
to create a new first on our repository, so that your pull request references
this issue.

If you are fixing a bug, it will be nice to add a unit test that exposes
the bug. Although this is not a requirement in most cases.

Be sure to follow [this](https://github.com/rubocop/ruby-style-guide) Ruby
style guide. We don't necessarily look for strict adherence to the guidelines
but too much a departure from it is frowned upon. For example, you will be forgiven
for writing a method with 15 to 20 lines if you clearly justify why you couldn't
break that method into multiple smaller methods.

## Publishing

To publish a new version of the gem, first update the version number in
`lib/lab/version.rb` and then run the following command:

```bash
$ gem build his_emr_api_lab.gemspec
$ gem push his_emr_api_lab-<version>.gem  
```
Make sure to replace `<version>` with the version number you set in `lib/lab/version.rb`.

NB: You need to have an account on [rubygems.org](https://rubygems.org/) and permission to publish gems.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
