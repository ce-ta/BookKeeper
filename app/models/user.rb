class User < ApplicationRecord
    mount_uploader :avatar, AvatarUploader
    has_many :books, dependent: :destroy
    has_secure_password
    
    validates :name, {presence: true, uniqueness: true}
    validates :email, {presence: true, uniqueness: true}
    validates :password, {presence: true, length: { minimum: 8 }}
end
