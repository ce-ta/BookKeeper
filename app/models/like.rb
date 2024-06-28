class Like < ApplicationRecord
  belongs_to :likeable, polymorphic: true
  belongs_to :user
  belongs_to :post
end
