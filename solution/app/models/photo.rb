class Photo < ApplicationRecord
  belongs_to :user
  has_many :comments
  
  validates :image, presence: true
end
