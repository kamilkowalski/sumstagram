class Photo < ApplicationRecord
  belongs_to :user
  has_many :comments
  
  validates :image, presence: true
  
  mount_base64_uploader :image, PhotoUploader
end
