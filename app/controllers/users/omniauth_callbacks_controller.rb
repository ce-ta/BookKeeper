class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
    skip_before_action :verify_authenticity_token, only: :github

    def github
      # userモデルのform_omniauthメソッドを呼び出し、OmniAuth認証に成功すると「request.env["omniauth.auth"]」に認証情報が格納される
      @user = User.from_omniauth(request.env["omniauth.auth"])
  
      # すでにユーザーが存在する場合
      if @user.persisted?
        # sign_in_and_redirectメソッドで@userをサインインさせ、指定先にリダイレクトさせる
        sign_in_and_redirect @user
        #flashメッセージを設定する
        set_flash_message(:notice, :success, kind: "Github")

      # ユーザーが存在しない場合
      else
        # 認証情報を「devidr.github_data」に保存する。この時、不要なデータ(extra)を取り除く
        session["devise.github_data"] = request.env["omniauth.auth"].except(:extra)
        redirect_to new_user_registration_url
      end
    end

    def google_oauth2
      # userモデルのform_omniauthメソッドを呼び出し、OmniAuth認証に成功すると「request.env["omniauth.auth"]」に認証情報が格納される
      @user = User.from_omniauth(request.env['omniauth.auth'])
  
      # すでにユーザーが存在する場合
      if @user.persisted?
        # sign_in_and_redirectメソッドで@userをサインインさせ、指定先にリダイレクトさせる
        sign_in_and_redirect @user
        #flashメッセージを設定する
        set_flash_message(:notice, :success, kind: 'Google')

      # ユーザーが存在しない場合
      else
        # 認証情報を「devidr.google_data」に保存する。この時、不要なデータ(extra)を取り除く
        session['devise.google_data'] = request.env['omniauth.auth'].except(:extra)
        redirect_to new_user_registration_url
      end
    end
  
    def failure
      redirect_to root_path
    end
end
