class AccessTokensController < ApplicationController
  def create
    if params[:email].present?
      user = User.find_by(email: params[:email])
    elsif params[:username].present?
      user = User.find_by(username: params[:username])
    else
      user = nil
    end

    if !user
      render json: { errors: ["Nie znaleziono podanego użytkownika"] }, status: :not_found
    elsif !user.authenticate(params[:password])
      render json: { errors: ["Niepoprawne hasło dla podanego użytkownika"] }, status: :unauthorized
    else
      token = CreateTokenService.new(user).call
      render json: token, status: :created
    end
  end

  def update
  end
end
