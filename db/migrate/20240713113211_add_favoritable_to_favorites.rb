class AddFavoritableToFavorites < ActiveRecord::Migration[7.1]
  def change
    add_column :favorites, :favoritable_type, :string
    add_column :favorites, :favoritable_id, :integer
  end
end
