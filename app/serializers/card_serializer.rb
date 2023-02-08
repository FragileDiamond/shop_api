class CardSerializer < ActiveModel::Serializer
  attributes :bonuses

  belongs_to :user, serializer: UserSerializer do
    include_data false
    link(:related) { "/api/v1/users/#{object.user_id}" }
  end

  belongs_to :shop, serializer: ShopSerializer do
    include_data false
    link(:related) { "/api/v1/shops/#{object.shop_id}" }
  end
end
