class AddGenreToposts < ActiveRecord::Migration[7.1]
  def change
    add_column :posts, :genre, :string
  end
end
