class SessionsController < ApplicationController
  
  def new
    @user = User.new
  end

  def create
    #  メールアドレスをもとにユーザーを検索する
    @user = User.find_by(email: params[:email])

    # ユーザーが見つかり、尚且つ、authenticateメソッドで、入力されたパスワードとパッシュ化されて保存されているパスワードが合っているかを確認する
    if @user && @user.authenticate(params[:password])

      # log_inメソッドを使って、ユーザーをログイン状態にする
      log_in(@user)
      flash[:success] = "ログインしました"
      redirect_to books_path
    else
      flash.now[:alert] = "メールアドレスまたはパスワードが間違っています"
      render :new
    end
  end

  def destroy
    log_out
    flash[:success] = "ログアウトしました"
    redirect_to login_path
  end

  private

  def log_in(user)
    session[:user_id] = user.id
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

  # ログアウト後にリダイレクトさせるパスを設定する
  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

  # セッションがタイムアウトした時にリダイレクトさせるパスを設定する
  def after_timeout_path_for(resource_or_scope)
    flash[:alert] = "セッションがタイムアウトしました。再度ログインしてください"
    new_user_session_path
  end

end

  