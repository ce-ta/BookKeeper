class Book < ApplicationRecord
    # mount_uploaderメソッドでbook_imageカラムにファイルのアップロード機能を追加、アップローダーとモデルの関連付け、ファイル処理のカスタマイズを行う
    mount_uploader :book_image, BookImageUploader
    belongs_to :user
    
    # precenceオプションで空白を防ぎ、lengthオプションで最大文字数を制限する
    validates :title, presence: true, length: { maximum: 30 }
    validates :author, presence: true, length: { maximum: 20 }
    validates :publisher, presence: true, length: { maximum: 10 }
    validates :genre, presence: true
    validates :date, presence: true
end
