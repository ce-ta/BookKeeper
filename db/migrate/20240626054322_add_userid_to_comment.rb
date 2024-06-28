class AddUseridToComment < ActiveRecord::Migration[7.1]
  def change
    add_column :comments, :user_id, :integer
    add_foreign_key :comments, :users
    add_index :comments, :user_id
  end
end
