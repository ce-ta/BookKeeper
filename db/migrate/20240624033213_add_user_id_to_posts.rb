class AddUserIdToPosts < ActiveRecord::Migration[7.1]
  def change
    add_foreign_key :posts, :users
  end
end
