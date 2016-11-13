class UsersController < ApplicationController
  def create
    user_params = params.permit(:username, :email, :password)
    user = User.new(user_params)
    
    if user.valid?
      user.save
      render json: {}, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :bad_request
    end
  end
end
