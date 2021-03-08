class AddDeadlineToProjects < ActiveRecord::Migration[6.0]
  def change
    add_column :projects, :deadline, :timestamp, null: false
  end
end
