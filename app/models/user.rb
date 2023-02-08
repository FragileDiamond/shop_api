class User < ApplicationRecord
  has_many :cards
  has_many :shops, through: :cards

  validates :email, presence: true, uniqueness: true
end
