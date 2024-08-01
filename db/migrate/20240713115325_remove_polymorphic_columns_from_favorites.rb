class RemovePolymorphicColumnsFromFavorites < ActiveRecord::Migration[7.1]
  def change
    remove_column :favorites, :comment_id, :integer
    remove_column :favorites, :favoritable_type, :string
    remove_column :favorites, :favoritable_id, :integer
  end
end
