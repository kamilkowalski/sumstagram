class User < ApplicationRecord
  has_one :access_token
  has_secure_password
  
  validates :username, :email, presence: true, uniqueness: true
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
end
