class ShopSerializer < ActiveModel::Serializer
  attributes :name

  has_many :cards, serializer: CardSerializer do
    include_data false
    link(:related) { "/api/v1/cards?filter[shop_id]=#{object.id}" }
    cards = object.cards
    cards.loaded? ? cards : cards.none
  end

  has_many :users, serializer: UserSerializer do
    include_data false
    link(:related) { "/api/v1/users?filter[shop_id]=#{object.id}" }
    users = object.users
    users.loaded? ? users : users.none
  end
end