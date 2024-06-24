class ApplicationController < ActionController::Base
    before_action :set_current_user
    helper_method :current_user, :logged_in?
    protect_from_forgery with: :exception
  
    def logged_in?
      session[:user_id].present?
    end
  
    def set_current_user
      @current_user = User.find_by(id: session[:user_id]) if session[:user_id]
    end
  
    def authenticate_user
      if @current_user.nil?
        flash[:login] = "ログインしてください"
        redirect_to login_path
      end
    end
  
    def forbid_login_user
      if @current_user
        flash[:success] = "すでにログインしています"
        redirect_to root_path # 適切なリダイレクト先に変更する必要があります
      end
    end
  
    private
  
    def current_user
      @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
    end
  
    def authenticate_user!
      redirect_to login_path, alert: "ログインしてください" unless current_user
    end
  end  