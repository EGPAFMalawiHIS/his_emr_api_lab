Rails.application.routes.draw do
  mount Lab::Engine => '/'

  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
end
