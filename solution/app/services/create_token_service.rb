class CreateTokenService
  def initialize(user)
    @user = user
  end
  
  def call
    ActiveRecord::Base.transaction do
      @user.access_token.destroy! if @user.access_token

      @user.create_access_token!(
        code: generate_code,
        expires_at: 2.weeks.from_now
      )
    end
  end
  
  private
  
  def generate_code
    code = nil
    
    loop do
      code = SecureRandom.base58(24)
      break unless AccessToken.exists?(code: code)
    end
    
    code
  end
end