# frozen_string_literal: true

class AddressSelectComponent < ViewComponent::Base
  def initialize(model)
    super

    @model = model

    # if model is a customer, use customer.user instead if user is not nil
    @model = model.user if model.is_a?(Customer) && !model.user.nil?
  end
end
