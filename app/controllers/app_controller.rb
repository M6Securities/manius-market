# frozen_string_literal: true

class AppController < ApplicationController
  before_action :authenticate_user!
  before_action :check_user_enabled
end
