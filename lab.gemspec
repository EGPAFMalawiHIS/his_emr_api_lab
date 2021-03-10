$:.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'lab/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = 'lab'
  spec.version     = Lab::VERSION
  spec.license     = 'MIT'
  spec.authors     = ['Elizabeth Glaser Pediatric Foundation Malawi']
  spec.email       = ['emrdevelopersmalawi@pedaids.org']
  spec.homepage    = 'https://github.com/EGPAFMalawiHIS/HIS-EMR-API'
  spec.summary     = 'Lab extension for the HIS-EMR-API'
  spec.description = <<~DESC
    This adds a lab interface to the OpenMRS compatible core API provided by
    [HIS-EMR-API](https://github.com/EGPAFMalawiHIS/HIS-EMR-API).
  DESC

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  spec.add_dependency 'couchrest'
  spec.add_dependency 'rails', '~> 5.2.4', '>= 5.2.4.3'
  spec.add_development_dependency 'bcrypt'
  spec.add_development_dependency 'factory_bot_rails'
  spec.add_development_dependency 'faker'
  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'rswag-api'
  spec.add_development_dependency 'rswag-specs'
  spec.add_development_dependency 'rswag-ui'
  spec.add_development_dependency 'rubocop', '~> 0.79.0'
  spec.add_development_dependency 'rubocop-rspec'
  spec.add_development_dependency 'shoulda-matchers'

  spec.add_development_dependency 'sqlite3'
end
