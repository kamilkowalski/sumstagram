class AccessTokenSerializer < ActiveModel::Serializer
  attributes :code, :expires_at
end
