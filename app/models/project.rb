class Project < ApplicationRecord

  validates :name, presence: true

  has_many :user_projects, dependent: :destroy
  has_many :users, through: :user_projects
end
