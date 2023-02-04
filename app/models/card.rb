class Card < ApplicationRecord
  belongs_to :shop
  belongs_to :user
end
