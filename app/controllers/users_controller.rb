class UsersController < ApplicationController
    before_action :authenticate_user, {only: [:show, :edit, :update]}
    before_action :forbid_login_user, {only: [:new, :create, :login_form, :login]}
    before_action :ensure_correct_user, {only: [:edit, :update]}

    def new
      @user = User.new
    end

    def create
      @user = User.new(user_params)
      if @user.save
        flash[:notice] = "ユーザー登録が完了しました"
        redirect_to user_path(@user)
      else
        flash[:signup_error] = "パスワードは8文字以上にしてください"
        render :new
      end
    end

    def show
      @user = User.find_by(id: params[:id])
    end

    def edit
      @user = User.find_by(id: params[:id])
    end
    
    def update
      @user = User.find_by(id: params[:id])
      if @user.update(user_params)
        flash[:user_update] = "ユーザー情報を編集しました"
        redirect_to user_path(@user)
      else
        render :edit
      end
    end
    
    def login_form
    end
  
    def login
      @user = User.find_by(email: params[:email], password: params[:password])
      if @user
        session[:user_id] = @user.id
        flash[:success] = "ログインしました"
        redirect_to books_path
      else
        @error_message = "メールアドレスまたはパスワードが間違っています"
        @input_email = params[:email]
        render "users/login_form"
      end
    end
  
    def logout
      session[:user_id] = nil
      flash[:login] = "ログアウトしました"
      redirect_to("/login")
    end

    def ensure_correct_user
      if @current_user.id != params[:id].to_i
        flash[:success] = "権限がありません"
        redirect_to("/book/index")
      end
    end
  
    private
  
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :avatar)
    end
    
end