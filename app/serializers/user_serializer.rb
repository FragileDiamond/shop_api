class UserSerializer < ActiveModel::Serializer
  attributes :email, :negative_balance

  has_many :cards, serializer: CardSerializer do
    include_data false
    link(:related) { "/api/v1/cards?filter[user_id]=#{object.id}" }
    cards = object.cards
    cards.loaded? ? cards : cards.none
  end

  has_many :shops, serializer: ShopSerializer do
    include_data false
    link(:related) { "/api/v1/shops?filter[user_id]=#{object.id}" }
    shops = object.shops
    shops.loaded? ? shops : shops.none
  end
end