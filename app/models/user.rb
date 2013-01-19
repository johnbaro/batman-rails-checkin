class User < ActiveRecord::Base
  attr_accessible :email, :name, :login, :access_token

  has_many :checkins

  before_save { |user| user.email = email.downcase }
  before_create :create_remember_token

  validates :login, presence: true, uniqueness: { case_sensitive: false }

  def latest_checkin
    checkins.order("created_at DESC").first
  end

  def gravatar_url
    "//gravatar.com/avatar/#{Digest::MD5::hexdigest(email.downcase)}?size=45&d=identicon"
  end

  private

  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end
end
