desc 'Generate openapi/swagger documentation template in engine'
task :swag, ['app:rswag:specs:swaggerize'] do
  source = 'spec/dummy/swagger/v1/swagger.yaml'
  destination = 'lib/generators/lab/install/templates/swagger.yaml'

  FileUtils.copy(source, destination)
end

namespace :lab do
  desc 'Install Lab engine into container application'
  task :install do
    puts '=> rails generate lab:install'
    `rails generate lab:install`

    puts '=> rake lab:install:migrations'
    `rake lab:install:migrations`
  end

  desc 'Uninstall Lab engine from container application'
  task :uninstall do
    puts '=> rails destroy lab:install'
    `rails destroy lab:install`
  end
end
