class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  validates :name, presence: true
  has_many :opinions, dependent: :destroy
  has_many :fairs, through: :opinions
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:github]
  ratyrate_rater

  def to_s
    name
  end

  def self.from_omniauth(access_token)
      data = access_token.info
      user = User.where(email: data['email']).first
      # Uncomment the section below if you want users to be created if they don't exist
      unless user
      user = User.create(
        email: data['email'],
        password: Devise.friendly_token[0,20]
      )
      end
    user
  end

end
