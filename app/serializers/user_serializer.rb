class UserSerializer < ActiveModel::Serializer
  attributes :email, :negative_balance
end
