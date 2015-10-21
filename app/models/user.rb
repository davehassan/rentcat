class User < ActiveRecord::Base
  attr_reader :password

  validates :user_name, :password_digest, :session_token, presence: true
  validates :password, length: { minimum: 6, allow_nil: true}
  validates :session_token, uniqueness: true

  # before_validation :ensure_session_token

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def password_digest
    BCrypt::Password.new(super)
  end


  def reset_session_token!
    self.session_token = SecureRandom::urlsafe_base64
    self.save!
  end

  def find_by_credentials(user_name, password)
    #returns nil if credentials are no good
    user = User.find_by(user_name: user_name)
    return nil unless user
    user.is_password?(password) ? user : nil
  end

  def is_password?(password)
    self.password_digest.is_password?(password)
  end

end
