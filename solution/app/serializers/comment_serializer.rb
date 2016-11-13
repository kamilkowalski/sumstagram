class CommentSerializer < ActiveModel::Serializer
  attributes :content, :created_at
  belongs_to :user, key: :author
end
