class RemoveCommentIdFromFavorites < ActiveRecord::Migration[7.1]
  def change
    change_column_null :favorites, :comment_id, true
  end
end
