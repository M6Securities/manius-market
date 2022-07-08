# frozen_string_literal: true

# handles all errors in the app and displays appropriate error page
class ErrorController < ApplicationController
  include Gaffe::Errors

  layout 'error'
  # Make sure anonymous users can see the page
  # skip_before_action :authenticate_user!

  # Render the correct template based on the exception “standard” code.
  # Eg. For a 404 error, the `errors/not_found` template will be rendered.
  def show

    # Here, the `@exception` variable contains the original raised error
    render "error/#{@rescue_response}", status: @status_code, template: "error/#{@rescue_response}"
  end
end