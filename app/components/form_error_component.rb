# frozen_string_literal: true

# displays form errors nicely
class FormErrorComponent < ViewComponent::Base

  def initialize(error:)
    @error = error
    super
  end

end
