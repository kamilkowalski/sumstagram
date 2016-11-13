class CreateTokenService
  def initialize(user)
    @user = user
  end
  
  def call
    AccessToken.create!(
      code: generate_code,
      expires_at: 2.weeks.from_now,
      user: @user
    )
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