# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Defines the root path route ("/")
  root 'root#index'

  scope '(:locale)', locale: /#{I18n.available_locales.join("|")}/ do

    devise_for :users

    namespace :app do

      resources :dashboard, only: %i[index]

      resources :market, only: %i[new create show edit]

      resources :product
      get '/product_datatable' => 'product#datatable'

      namespace :site_admin do

        resources :user
        get 'user_datatable' => 'user#datatable'
        resources :market
        get 'market_datatable' => 'market#datatable'

      end
      get '/site_admin' => 'site_admin#index'

    end
    get '/app' => 'app#index'
    match '/app/set_market' => 'app#set_market', via: %i[post put patch]
  end

  # shortcuts
  get '/l', to: redirect('/users/sign_in')
  get '/login', to: redirect('/users/sign_in')
end
