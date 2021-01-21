class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  has_many :posts, dependent: :destroy

  validates :name, :profile, :image, presence: true

  enum profile: { admin: 0, client: 1 }
end
