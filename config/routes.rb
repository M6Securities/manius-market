Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  scope '(:locale)', locale: /#{I18n.available_locales.join("|")}/ do
    devise_for :users

    namespace :app do
      root 'app#index'

      resources :markets

    end
  end

  mount Spina::Engine => '/'
end
