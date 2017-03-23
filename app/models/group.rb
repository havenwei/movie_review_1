class Group < ApplicationRecord
  belongs_to :user
  has_many :posts, dependent: :destroy
  validates :title, presence: true

  has_many :group_relationships
  has_many :members, through: :group_relationships, source: :user

  has_attached_file :image, styles: {large: "600x600>", medium: "300x300>", thumb: "150x150#"}
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
end
