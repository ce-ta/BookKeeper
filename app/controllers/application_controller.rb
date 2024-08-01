class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

    # サインイン後に登録書籍一覧ページに飛ばす
    def after_sign_in_path_for(resource)
      books_path
    end
  
    protected

    # devise_parameter_sanitizerメソッドで、送信するパラメータを制限し、サインアップ時・アカウント更新時にkeysのパラメータのみ送信させる
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :avatar, :bio])
      devise_parameter_sanitizer.permit(:account_update, keys: [:name, :avatar, :bio])
    end
  end  