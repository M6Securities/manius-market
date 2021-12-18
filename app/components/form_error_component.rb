# frozen_string_literal: true

# displays form errors nicely
class FormErrorComponent < ViewComponent::Base

  def initialize(message_hash)
    @messages = message_hash.values
  end

end
