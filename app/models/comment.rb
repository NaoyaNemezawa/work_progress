class Comment < ApplicationRecord
  validates :comment, presence: true, unless: :img_cached?

  mount_uploader :img, ImgUploader
  belongs_to :user
  belongs_to :task

  def img_cached?
    self.img.cached?
  end
end
