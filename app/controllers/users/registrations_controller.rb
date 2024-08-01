class Users::RegistrationsController < Devise::RegistrationsController
    protected
  
    # update_without_passwordメソッドでパスワードなしでユーザー情報を更新できる。resourceは現在のユーザーオブジェクト
    def update_resource(resource, params)
      resource.update_without_password(params)
    end
  
    # 編集後にユーザー詳細ページにリダイレクトする
    def after_update_path_for(resource)
      user_path(resource)
    end
  end