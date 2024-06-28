class SessionsController < ApplicationController
  before_action :forbid_login_user, only: [:new, :create]
  
  def new
    @user = User.new
  end

  def create
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      flash[:success] = "ログインしました"
      redirect_to books_path
    else
      flash.now[:alert] = "メールアドレスまたはパスワードが間違っています"
      render 'new'
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

  def forbid_login_user
    redirect_to root_path if logged_in?
  end
end

  