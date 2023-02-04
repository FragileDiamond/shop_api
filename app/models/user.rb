class User < ApplicationRecord
  has_many :shops, through: :cards
  has_many :cards
end
