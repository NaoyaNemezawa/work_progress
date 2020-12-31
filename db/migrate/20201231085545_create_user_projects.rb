class CreateUserProjects < ActiveRecord::Migration[6.0]
  def change
    create_table :user_projects do |t|
      t.references :user, foregin_key: true
      t.references :project, foregin_key: true

      t.timestamps
    end
  end
end
