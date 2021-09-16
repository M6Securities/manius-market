# frozen_string_literal: true

module App
  # Handles user facing market stuff
  class MarketController < AppController

    def create
      safe_params = params.require(:create).permit(:display_name, :path_name, :email)
    end

  end
end
