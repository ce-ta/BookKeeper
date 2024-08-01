class AddGenreToComments < ActiveRecord::Migration[7.1]
  def change
    add_column :comments, :genre, :string
  end
end
