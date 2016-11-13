class UsersController < ApplicationController
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
