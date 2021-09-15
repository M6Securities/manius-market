Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  scope '(:locale)', locale: /#{I18n.available_locales.join("|")}/ do

    devise_for :users

    namespace :app do

      resources :dashboard, only: %i[index]

      resources :market

      resources :user

    end
    get '/app' => 'app#index'
  end

  # shortcuts
  get '/l', to: redirect('/users/sign_in')
  get '/login', to: redirect('/users/sign_in')

  mount Spina::Engine => '/'
end
