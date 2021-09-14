Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  scope '(:locale)', locale: /#{I18n.available_locales.join("|")}/ do

    root 'app/dashboard#index'

    devise_for :users

    namespace :app do
      root 'dashboard#index'

      resources :dashboard

      resources :market

      resources :user

    end
  end

  mount Spina::Engine => '/'
end
