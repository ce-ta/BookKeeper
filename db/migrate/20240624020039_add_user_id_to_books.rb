class AddUserIdToBooks < ActiveRecord::Migration[7.1]
  def change
    add_reference :books, :user, null: true,  foreign_key: true
  end
end
