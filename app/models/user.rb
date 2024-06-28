class User < ApplicationRecord
    mount_uploader :avatar, AvatarUploader
    has_many :books, dependent: :destroy
    has_many :posts, dependent: :destroy
    has_many :likes, dependent: :destroy
    has_many :comments, dependent: :destroy
    has_secure_password
    
    
    validates :name, presence: true, uniqueness: true
    validates :email, presence: true, uniqueness: true
    validates :password, presence: true, length: { minimum: 8 }, if: :password_required?
    validates :password_confirmation, presence: true, if: :password_required?
    validate :password_match_validation, if: -> { new_record? || password.present? }
    validates :bio, length: { maximum: 100 }

    def has_liked?(post)
        liked_posts.include?(post)
    end

    private

    def password_required?
        new_record? || password.present?
    end

    def password_match_validation
        unless password == password_confirmation
          errors.add(:password_confirmation, "confirmation doesn't match Password")
        end
    end
end
