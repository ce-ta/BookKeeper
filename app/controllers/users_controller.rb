class UsersController < ApplicationController
  before_action :authenticate_user, only: [:show, :edit, :update]
  before_action :ensure_correct_user, only: [:edit, :update]
  before_action :set_user, only: [:show, :edit, :update]
  

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
  
    if @user.save
      session[:user_id] = @user.id
      flash[:success] = "ユーザー登録が完了しました"
      redirect_to books_path
    else
      flash.now[:signup_errors] = generate_signup_errors(@user.errors)
      render :new
    end
  end

  def show
    @posts = @user.posts
  end

  def edit
  end

  def update
    if params[:user][:password].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end
    
    if @user.update(user_params)
      flash[:success] = "ユーザー情報を更新しました"
      redirect_to user_path(@user)
    else
      flash.now[:signup_errors] = generate_signup_errors(@user.errors)
      render :new
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :avatar, :bio)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    redirect_to root_path unless current_user == @user
  end

  def generate_signup_errors(errors)
    error_messages = []
    
    if errors[:name].include?("has already been taken")
      error_messages << "すでに同じ名前のユーザーがいます"
    end
    
    if errors[:email].include?("has already been taken")
      error_messages << "このメールアドレスは既に使用されています"
    end
    
    if errors[:password_confirmation].any? && errors[:password_confirmation].include?("confirmation doesn't match Password")
      error_messages << "パスワードと確認用パスワードが一致しません"
    end
    
    if errors[:password].any?
      error_messages << "パスワードは8文字以上で入力してください"
    end
    
    if errors[:bio].any?
      error_messages << "自己紹介は100文字以内で入力してください"
    end
    
    error_messages << "ユーザー情報の更新に失敗しました" if error_messages.empty?
    
    error_messages
  end
end