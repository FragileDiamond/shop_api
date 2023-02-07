class Shop < ApplicationRecord
  has_many :cards
  has_many :users, through: :cards
end
