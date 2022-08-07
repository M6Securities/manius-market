require 'currency_select'

module ApplicationHelper
  include Pagy::Frontend

  def currency_code_select_array
    CurrencySelect.currencies_array
  end
end
