# frozen_string_literal: true

Rails.application.routes.draw do
  # Defines the root path route ("/")
  root 'root#index'

  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
end
