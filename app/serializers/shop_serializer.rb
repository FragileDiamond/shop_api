class ShopSerializer < ActiveModel::Serializer
  has_many :cards, serializer: CardSerializer do
    include_data false
    link(:related){"/api/v1/cards?filter[shop_id]=#{object.id}"}
  end
  has_many :users, through: :cards, serializer: UserSerializer do
    include_data false
    link(:related) { "/api/v1/users?filter[shop_id]=#{object.id}" }
  end

  attributes :name
end
