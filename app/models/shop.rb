class Shop < ApplicationRecord
  has_many :cards
  has_many :users, through: :cards

  validates :name, :presence => true, uniqueness: true
end
