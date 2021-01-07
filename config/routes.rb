# frozen_string_literal: true

Lab::Engine.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs/lab'
  mount Rswag::Api::Engine => '/api-docs/lab'

  resources :orders, path: 'api/v1/lab/orders' do
    resources :specimens, controller: 'order_specimens', except: %i[update]
  end

  resources :tests, path: 'api/v1/lab/tests' # ?pending=true to select tests without results?

  # Metadata
  resources :specimen_types, only: %i[index], path: 'api/v1/lab/specimen_types'
  resources :test_types, only: %i[index], path: 'api/v1/lab/test_types'
end
