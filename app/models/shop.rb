class Shop < ApplicationRecord
  has_many :users, through: :cards
  has_many :cards
end
