class UsersController < ApplicationController
  skip_before_action :check_access_token_presence, :check_access_token_expiration, only: [:create]

  def create
    user_params = params.permit(:username, :email, :password)
    user = User.new(user_params)
    
    if user.valid?
      user.save!
      token = CreateTokenService.new(user).call
      render json: token, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :bad_request
    end
  end
end
