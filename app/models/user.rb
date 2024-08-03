class User < ApplicationRecord
  devise :database_authenticatable, # パスワードをデータベースで管理する機能
         :registerable, # ユーザーの新規登録、アカウントの編集・削除をする機能
         :recoverable, # パスワードリセット機能
         :rememberable, # ユーザーのログインセッションを管理する機能
         :validatable, # バリデーションを行う機能
         :omniauthable, # 外部認証サービスとの連携を可能にする機能
         omniauth_providers: %i[github google_oauth2] # OmniAuthを使った認証プロバイダーを指定する

  # mount_uploaderメソッドでavatarカラムにファイルのアップロード機能を追加、アップローダーとモデルの関連付け、ファイル処理のカスタマイズを行う
  has_one_attached :avatar

  # has_manyオプションでPostモデルが複数のcomennt等を持つことを許可し、dependentオプションで、関連づけられた投稿が削除された時に一緒に削除されるようにする
  has_many :books, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :authorizations, dependent: :destroy

  # throughオプションで中間テーブルfavotitesを通じてpostモデルと関連付け、sourceオプションでfavoritesテーブルに関連づけられたpostを取得する
  # 投稿とユーザーが多対多の関係にあるため、中間テーブルを使用する
  has_many :favorited_posts, through: :favorites, source: :post
    
    # precenceメソッドで空白を防ぎ、uniquenessオプションで一意性を確保する
    validates :name, presence: true, uniqueness: true, length: { maximum: 25 }
    validates :email, presence: true, uniqueness: true, length: { maximum: 255 }

    # lengthオプションで最大文字数を指定する
    validates :bio, length: { maximum: 100 }

    private

    # 新規作成時とパスワード更新時のみバリデーションが実行されるようにするメソッド
    def password_required?
        # new_recode?メソッドで新しいレコードであればtrueを返すようにする
        # password.present?メソッドでパスワードが設定済みであればtrueを返すようにする
        new_record? || password.present?
    end

    # パスワードと確認用パスワードが一致しない場合にエラーメッセージを表示するメソッド
    def password_match_validation
        # 一致しない場合、エラーメッセージを追加する
        unless password == password_confirmation
          errors.add(:password_confirmation, "確認用パスワードと一致しません")
        end
    end

    # 外部認証プロバイダーからの情報を使ってユーザーを作成・更新するメソッド
    def self.from_omniauth(auth)
      # find_or_initialize_byメソッドで、認証プロバイダーとユーザーIDでAuthorizationモデルを検索する。見つからない場合は初期化する
      authorization = Authorization.find_or_initialize_by(provider: auth.provider, uid: auth.uid)

      # assign_attributesメソッドでauthorizationオブジェクトに、認証プロバイダーから取得したユーザー名とメールアドレスを設定する
      authorization.assign_attributes(name: auth.info.name, email: auth.info.email)
    
      # whereメソッドで認証プロバイダーから取得したメールアドレスでユーザーを検索する
      # first_or_initializeメソッドで最初に引っかかったレコードを取得するか、ない場合はインスタンスを初期化する
      # tapメソッドで、オブジェクトに対してブロックないで操作を行い、そのオブジェクトを返す
      where(email: auth.info.email).first_or_initialize.tap do |user|

        # ユーザー名が未設定の場合のみ設定
        user.name ||= auth.info.name

        # avatarに認証プロバイダーから取得したユーザー画像のURLを設定する
        user.avatar = auth.info.image
  
        # Devise.friendly_tokenメソッドで、セキュアなトークンを生成し、[0, 20]を使い、最初の20文字を取り出す
        # user.new_recode?メソッドで、userインスタンスが新しいレコードの場合、実行する
        user.password = Devise.friendly_token[0, 20] if user.new_record?
  
        user.save!
        # すでに同じproviderとuidを持つauthorizetionオブジェクトがない場合に、user.authorizationにオブジェクトを追加する
        user.authorizations << authorization unless user.authorizations.exists?(provider: auth.provider, uid: auth.uid)
      end
    end
end
