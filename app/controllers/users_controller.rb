class UsersController < ApplicationController
  before_action :authenticate_user, only: [:show, :edit, :update]
  before_action :ensure_correct_user, only: [:edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:success] = "ユーザー登録が完了しました"
      redirect_to user_path(@user)
    else
      flash.now[:error] = "ユーザー登録に失敗しました"
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      flash[:success] = "ユーザー情報を更新しました"
      redirect_to user_path(@user)
    else
      flash.now[:error] = "ユーザー情報の更新に失敗しました"
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :avatar)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    redirect_to root_path unless current_user == @user
  end
end