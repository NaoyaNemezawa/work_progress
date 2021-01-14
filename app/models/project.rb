class Project < ApplicationRecord

  validates :name, presence: true

  has_many :user_projects, dependent: :destroy
  has_many :users, through: :user_projects
  has_many :tasks, dependent: :destroy
end
