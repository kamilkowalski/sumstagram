class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :photo
  
  validates :content, presence: true
end
