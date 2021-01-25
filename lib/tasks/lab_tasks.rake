desc 'Generate openapi/swagger documentation'
task :swag, ['app:rswag:specs:swaggerize'] do
  source = 'spec/dummy/swagger/v1/swagger.yaml'
  destination = 'lib/generators/lab/install/templates/swagger.yaml'

  FileUtils.copy(source, destination)
end
