Rails.application.routes.draw do
  mount Rswag::Ui::Engine, at: '/'
  mount Rswag::Api::Engine, at: '/'
  namespace :api do
    resources :sessions, only: :create
    resources :products do
      collection do
        get :populars
      end
    end
    resources :orders do
      member do
        get :products
      end
    end
  end
end
