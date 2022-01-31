class Receive < ApplicationRecord
  has_many :receive_items, dependent: :destroy
  belongs_to :market
  belongs_to :user
  has_many :action_logs, as: :loggable, dependent: :destroy
end
