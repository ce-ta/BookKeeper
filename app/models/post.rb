class Post < ApplicationRecord
    belongs_to :user

    # precenceオプションで空白を防ぎ、lengthオプションで最大文字数を制限する
    validates :title, presence: true
    validates :genre, presence: true
    validates :content, presence: true,  length: { maximum: 140 }
    validates :user_id, presence: true

    # has_manyオプションでPostモデルが複数のcomennt等を持つことを許可し、dependentオプションで、関連づけられた投稿が削除された時に一緒に削除されるようにする
    has_many :comments, dependent: :destroy
    has_many :favorites, dependent: :destroy

    # throughオプションで中間テーブルfavotitesを通じてuserモデルと関連付け、sourceオプションでfavoritesテーブルに関連づけられたuserを取得する
    # 投稿とユーザーが多対多の関係にあるため、中間テーブルを使用する
    has_many :favorited_by_users, through: :favorites, source: :user

    def user
        return User.find_by(id: self.user_id)
    end

    def favorited_by?(user)
        # whereメソッドでuser.idが一致するfavoritesを検索し、exists?メソッドで検索結果が存在するかを確認する
        favorites.where(user_id: user.id).exists?
    end
end
