class User < ActiveRecord:: Base
  has_many :microposts, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id",
           class_name: "Relationship",
           dependent: :destroy
  has_many :followers, through: :reverse_relationships, source: :follower
  # has_many :followers, through: :relationships, source: :follower
  before_create :create_activation_digest
  before_save { self.email = email.downcase }
  before_create :create_remember_token
  validates :name, presence: {message: "不能为空"}, length: { maximum:10,
                                                                           too_long: "最多输入10个字母或5个中文" }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: { message: "不能为空"},
            format: { with: VALID_EMAIL_REGEX,
                             message: "格式不正确" },
            uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, length: { minimum: 6,
                                                       message: "最少6位"}



  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def feed
    Micropost.from_users_followed_by(self)
  end

  def following?(other_user)
    relationships.find_by(followed_id: other_user.id)
  end
  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by(followed_id: other_user.id).destroy
  end

  private
  def create_remember_token
    self.remember_token = User.encrypt(User.new_remember_token)
  end

  def create_activation_digest
    self.activation_token  = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
