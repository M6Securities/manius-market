class ReceiveItem < ApplicationRecord
  belongs_to :receive
  belongs_to :product

  def user
    receive.user
  end

end
