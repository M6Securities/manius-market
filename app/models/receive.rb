class Receive < ApplicationRecord

  has_many :receive_items, dependent: :destroy
  belongs_to :market
  belongs_to :user


end
