# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'lab/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = 'his_emr_api_lab'
  spec.version     = Lab::VERSION
  spec.license     = 'MIT'
  spec.authors     = ['Elizabeth Glaser Pediatric Foundation Malawi']
  spec.email       = ['emrdevelopersmalawi@pedaids.org']
  spec.homepage    = 'https://github.com/EGPAFMalawiHIS/his_emr_api_lab'
  spec.summary     = 'Lab extension for the HIS-EMR-API'
  spec.description = <<~DESC
    This adds a lab interface to the OpenMRS compatible core API provided by
    [HIS-EMR-API](https://github.com/EGPAFMalawiHIS/HIS-EMR-API).
  DESC

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['source_code_uri'] = spec.homepage
  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  spec.add_dependency 'couchrest', '~> 2.0.0'
  spec.add_dependency 'parallel', '~> 1.20.1'
  spec.add_dependency 'rails', "~> 7.0.2", ">= 7.0.2.4"
  spec.add_dependency 'socket.io-client-simple', '~> 1.2.1'
  spec.add_development_dependency 'bcrypt', '~> 3.1.0'
  spec.add_development_dependency 'factory_bot_rails', '~> 6.1.0'
  spec.add_development_dependency 'faker', '~> 2.16.0'
  spec.add_development_dependency 'rspec-rails', '~> 5.0.0'
  spec.add_development_dependency 'rswag-api', '~> 2.5.1'
  spec.add_development_dependency 'rswag-specs', '~> 2.5.1'
  spec.add_development_dependency 'rswag-ui', '~> 2.5.1'
  spec.add_development_dependency 'rubocop', '~> 0.79.0'
  spec.add_development_dependency 'rubocop-rspec', '~> 1.41.0'
  spec.add_development_dependency 'shoulda-matchers', '~> 4.5.0'

  spec.add_development_dependency 'sqlite3', '~> 1.4.0'
end
