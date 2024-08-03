class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def show
    set_user
    @posts = @user.posts
    # 「include(:user)」でコメントに関連するユーザー情報も一緒に読み込むことで、N+1クエリ問題を防ぐ
    @comments = @user.comments.includes(:user)
    @favorite_posts = @user.favorited_posts
  end

  def edit
  end

  def update
    if @user.update
      flash[:success] = "ユーザー情報を更新しました"
      redirect_to books_path
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to "/"
    flash[:success] = "ユーザーを削除しました。"
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  # requireメソッドで:userというキーがあること確認し、permitメソッドで送信するカラムを制限する
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
      error_messages << "パスワードは6文字以上で入力してください"
    end
    
    if errors[:bio].any?
      error_messages << "自己紹介は100文字以内で入力してください"
    end
    
    error_messages << "ユーザー情報の更新に失敗しました" if error_messages.empty?
    
    error_messages
  end
end