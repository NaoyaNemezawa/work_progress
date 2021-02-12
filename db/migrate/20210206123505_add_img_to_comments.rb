class AddImgToComments < ActiveRecord::Migration[6.0]
  def change
    add_column :comments, :img, :string
  end
end
