Rails.application.routes.draw do
  mount Rswag::Ui::Engine, at: 'api_test-docs'
  mount Rswag::Api::Engine, at: 'api_test-docs'
  namespace :api do
    resources :session, only: :create
  end
end
