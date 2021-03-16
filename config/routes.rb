# frozen_string_literal: true

Lab::Engine.routes.draw do
  resources :orders, path: 'api/v1/lab/orders'
  resources :tests, path: 'api/v1/lab/tests', except: %i[update] do # ?pending=true to select tests without results?
    resources :results, only: %i[index create destroy]
  end

  # Metadata
  resources :specimen_types, only: %i[index], path: 'api/v1/lab/specimen_types'
  resources :test_result_indicators, only: %i[index], path: 'api/v1/lab/test_result_indicators'
  resources :test_types, only: %i[index], path: 'api/v1/lab/test_types'
end
