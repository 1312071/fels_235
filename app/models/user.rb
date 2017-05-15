class User < ApplicationRecord
  attr_accessor :remember_token

  before_save :downcase_email

  has_secure_password

  has_many :active_relationships, class_name: Relationship.name,
    foreign_key: :follower_id, dependent: :destroy
  has_many :passive_relationships, class_name: Relationship.name,
    foreign_key: :followed_id, dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :lessons, dependent: :destroy
  has_many :activities, dependent: :destroy, as: :target
  before_save :downcase_email
  validates :name, presence: true,
    length: {maximum: Settings.user.max_name_length}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true,
    length: {maximum: Settings.user.max_email_length},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}
  validates :password, length: {minimum: Settings.user.min_password_length},
    allow_nil: true

  class << self
    def digest string
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
      BCrypt::Engine.cost
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end

    def search query
      if query
        terms = query.downcase.split(/\s+/)
        terms = terms.map {|e|
          (e.gsub("*", "%") + "%").gsub(/%+/, "%")
        }
        num_or_conditions = 2
        where(
          terms.map {
            or_clauses = [
              "users.name LIKE ?",
              "users.email LIKE ?"
            ].join(" OR ")
            "(#{or_clauses})"
          }.join(" AND "),
          *terms.map {|e| [e] * num_or_conditions}.flatten
        )
      else
        all
      end
    end
  end

  def current_user? user
    self ==  user
  end
  def remember
    self.remember_token = User.new_token
    update_attributes remember_digest: User.digest(remember_token)
  end

  def authenticated? attribute, token
    digest = send "#{attribute}_digest"
    return false unless digest
    BCrypt::Password.new(digest).is_password? token
  end

  def forget
    update_attributes remember_digest: nil
  end

  def follow other_user
    active_relationships.create followed_id: other_user.id
  end

  def unfollow other_user
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following? other_user
    following.include? other_user
  end

  def feed
    following_ids = "SELECT followed_id FROM relationships
      WHERE follower_id = :user_id"
    Activity.where("user_id IN (#{following_ids})
      OR user_id = :user_id", user_id: self.id).order created_at: :DESC
  end

  private

  def downcase_email
    email.downcase!
  end
end
