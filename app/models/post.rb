class Post < ApplicationRecord
    validates :title, {presence: true}
    validates :content, {presence: true}
    validates :user_id, {presence: true}

    belongs_to :user

    has_many :posts

    def user
        return User.find_by(id: self.user_id)
    end
end
