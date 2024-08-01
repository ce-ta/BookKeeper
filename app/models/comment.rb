class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user
  
  # precenceオプションで空白を防ぎ、lengthオプションで最大文字数を制限する
  validates :body, presence: true, length: {maximum: 140}
end
