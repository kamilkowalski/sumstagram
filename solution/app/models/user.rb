class User < ApplicationRecord
    has_one :access_token
    has_secure_password
end
