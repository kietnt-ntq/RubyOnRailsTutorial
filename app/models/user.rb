class User < ApplicationRecord
  attr_accessor :remember_token
  before_save { self.email = email.downcase }
  validates :name,  presence: true, length:{maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness:  { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }         

  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

   # Returns a random token.
   def User.new_token
    SecureRandom.urlsafe_base64
  end

  # tao ra bien toan cuc remember_token va update vao truong remember_digest trong csdl
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # kiem tra remember_token tren client co phai la remerber_digest cua user hay ko?
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # cap nhat lai truong remember_digest = nil vao CSDL
  def forget
    update_attribute(:remember_digest, nil)
  end
end
