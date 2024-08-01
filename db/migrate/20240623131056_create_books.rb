class CreateBooks < ActiveRecord::Migration[7.1]
  def change
    create_table :books do |t|
      t.string "title"
      t.string "author"
      t.string "publisher"
      t.string "genre"
      t.date "date"
      t.string "book_image"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end
  end
end
