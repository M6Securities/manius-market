# frozen_string_literal: true

class AppController < ApplicationController
  layout 'app'

  before_action :authenticate_user!
  before_action :check_user_enabled

end
