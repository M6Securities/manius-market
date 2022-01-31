# frozen_string_literal: true

require 'sidekiq/web'
require 'sidekiq-scheduler/web'

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Defines the root path route ("/")
  root 'root#index'

  scope '(:locale)', locale: /#{I18n.available_locales.join("|")}/ do
    devise_for :users

    namespace :app do
      resources :dashboard, only: %i[index]

      scope path: :market, module: :market_space, as: :market_space do
        resources :market

        resources :product do
          get 'orders_datatable'
        end
        get 'product_datatable' => 'product#datatable'

        resources :user, except: %i[edit destroy] do
          get 'permissions'
          get 'remove'
          match 'remove' => 'user#remove_from_market', via: %i[post patch put delete]
        end
        get 'user_datatable' => 'user#datatable'
        get 'invite_user_to_market' => 'user#invite_user_to_market_view'
        match 'invite_user_to_market' => 'user#invite_user_to_market', via: %i[post patch put]

        resources :receiving do
          get 'line_item/:receive_item' => 'receiving#receiving_item_line', as: :item_line
        end
        get 'receiving_datatable' => 'receiving#datatable'

        resources :order, except: :destroy
        get 'order_datatable' => 'order#datatable'

        resources :customer, except: %i[edit update destroy] do
          get 'orders_datatable'
        end
        get 'customer_datatable' => 'customer#datatable'
      end

      get 'action_logs' => 'action_logs#datatable', as: :action_logs_datatable

      namespace :site_admin do
        resources :user
        get 'user_datatable' => 'user#datatable'
        resources :market
        get 'market_datatable' => 'market#datatable'

        # sidekiq
        authenticate :user, ->(user) { user.site_admin } do
          mount Sidekiq::Web => '/sidekiq'
        end
      end
      get '/site_admin' => 'site_admin#index'
    end

    get '/app' => 'app#index'
    match '/app/set_market' => 'app#set_market', via: %i[post put patch]

    # everything under this scope is NOT prefixed with /site
    scope module: :site do
      resources :product, only: %i[index show]

      scope :cart, as: :cart do
        get '' => 'cart#index'
        get 'navbar' => 'cart#navbar'
        match 'update_item' => 'cart#update_item', via: %i[post patch put]
        match 'update_cart' => 'cart#update_cart', via: %i[post patch put]
      end

      scope :stripe_checkout, as: :stripe_checkout do
        match 'create' => 'stripe_checkout#create', via: %i[post patch put]
        get 'success' => 'stripe_checkout#success', as: :success
        get 'cancel/:order_id' => 'stripe_checkout#cancel', as: :cancel
      end
    end
  end

  # API
  namespace :api, defaults: { format: :json } do
    namespace :webhook do
      scope :stripe, as: :stripe do
        match '/' => 'stripe#index', via: %i[post patch put]
      end
    end
  end

  # shortcuts
  get '/l', to: redirect('/users/sign_in')
  get '/login', to: redirect('/users/sign_in')
end
