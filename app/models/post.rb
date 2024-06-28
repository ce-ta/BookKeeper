class Post < ApplicationRecord
    validates :title, presence: true
    validates :content, presence: true
    validates :user_id, presence: true

    belongs_to :user
    has_many :comments, dependent: :destroy
    has_many :likes, as: :likeable, dependent: :destroy

    def user
        return User.find_by(id: self.user_id)
    end
end
