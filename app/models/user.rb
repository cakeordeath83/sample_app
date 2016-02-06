class User < ActiveRecord::Base
	
  attr_accessor :remember_token, :activation_token
  before_save :downcase_email
  before_create :create_activation_digest
  
  validates :name, presence: true, length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, 
                    length: {maximum: 255}, 
                    uniqueness: {case_sensitive: false},
                    format: {with: VALID_EMAIL_REGEX}
	
	has_secure_password
	#allow_nil means that when editing you don't have to update your password too.
	validates :password, length: {minimum: 6}, 
											 presence: true,
											 allow_nil: true
  
	# Only added so that we can create a valid user fixture which can be passed into the login tests
	def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
	
	# Returns a random token
	def User.new_token
		SecureRandom.urlsafe_base64
	end
	
	def remember
		self.remember_token = User.new_token
		update_attribute(:remember_digest, User.digest(remember_token))
	end
	
  # Changed so that it can use either remember or activation token
  # When called will pass in which type as the attribute
  # e.g. user.authenticated?(:remember, remember_token)
  def authenticated?(attribute, token)
    # as there is a remember_digest and authenticate_digest method, you can interpolate the word to call the correct one
    digest = self.send("#{attribute}_digest")
		return false if digest.nil?
		BCrypt::Password.new(digest).is_password?(token)
	end
	
	def forget
		update_attribute(:remember_digest, nil)
	end
  
  def activate
    # self is optional inside the model but I'm leaving it in for clarity
    self.update_attribute(:activated, true)
    self.update_attribute(:activated_at, Time.zone.now)
  end
  
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end
  
private
  
  # Downcase email for verification comparison
  def downcase_email
    self.email = email.downcase
  end
  
  # Creates and assigns the activation token and digest
  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
  
end
