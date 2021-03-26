# frozen_string_literal: true

require 'logger_multiplexor'

Rails.logger = LoggerMultiplexor.new(Rails.root.join('log/lims-push.log'), $stdout)
api = Lab::Lims::Api.new
worker = Lab::Lims::Worker.new(api)

case ARGV[0]&.downcase
when 'push'
  worker.push_orders
when 'pull'
  worker.pull_orders
else
  warn 'Error: No or invalid action specified: Valid actions are push and pull'
  warn 'USAGE: rails runner start_worker.rb push'
  exit 1
end
