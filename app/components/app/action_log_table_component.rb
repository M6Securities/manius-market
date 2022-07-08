# frozen_string_literal: true

module App
  class ActionLogTableComponent < ViewComponent::Base
    def initialize(model)
      @model = model
    end
  end
end
