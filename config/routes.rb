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
