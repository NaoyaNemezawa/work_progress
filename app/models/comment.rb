class Comment < ApplicationRecord
  validates :comment, presence: true

  mount_uploader :img, ImgUploader
  belongs_to :user
  belongs_to :task
end
