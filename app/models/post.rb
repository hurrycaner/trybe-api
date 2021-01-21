class Post < ApplicationRecord
  belongs_to :user

  validates :title, :content, presence: true
  validates :title, uniqueness: { case_sensitive: false }
end
