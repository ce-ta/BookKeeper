class Authorization < ApplicationRecord
    # userモデルと関連づける
    belongs_to :user

    # scopeオプションでuidのユニーク性をスコープ内で保証する。OAuthプロバイダーごとにユーザーを持たせる
    validates :uid, uniqueness: { scope: :provider }
end