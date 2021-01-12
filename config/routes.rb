# frozen_string_literal: true

require 'rswag/ui'
require 'rswag/api'

Lab::Engine.routes.draw do
  resources :orders, path: 'api/v1/lab/orders'
  resources :tests, path: 'api/v1/lab/tests' do # ?pending=true to select tests without results?
    resources :results, only: %i[index create]
  end

  # Metadata
  resources :specimen_types, only: %i[index], path: 'api/v1/lab/specimen_types'
  resources :test_types, only: %i[index], path: 'api/v1/lab/test_types'
end
