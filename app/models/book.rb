class Book < ApplicationRecord
    mount_uploader :book_image, BookImageUploader
    belongs_to :user
end
