class UserSerializer < ActiveModel::Serializer
  has_many :cards, serializer: CardSerializer do
    include_data false
    link(:related){"/api/v1/cards?filter[shop_id]=#{object.id}"}
  end
  has_many :shops, through: :cards, serializer: ShopSerializer do
    include_data false
    link(:related) { "/api/v1/users?filter[user_id]=#{object.id}" }
  end

  attributes :email, :negative_balance
end
