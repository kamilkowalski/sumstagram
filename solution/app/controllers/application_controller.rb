class ApplicationController < ActionController::API
  before_action :check_access_token_presence, :check_access_token_expiration
  
  private
  
  def check_access_token_presence
    unless current_token
      render json: { errors: ["Musisz podać istniejący token autoryzacyjny"] }, status: :bad_request
    end
  end
  
  def check_access_token_expiration
    if current_token.expires_at < Time.current
      render json: { errors: ["Token autoryzacyjny wygasł"] }, status: :unauthorized
    end
  end
  
  def current_token
    @current_token ||= AccessToken.find_by(code: params[:access_token])
  end
  
  def current_user
    @current_user ||= current_token.try(:user)
  end
end
