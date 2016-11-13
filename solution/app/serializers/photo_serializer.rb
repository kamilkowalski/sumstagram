class PhotoSerializer < ActiveModel::Serializer
  attributes :id, :image_url, :created_at
  belongs_to :user, key: :author
  has_many :comments
end
