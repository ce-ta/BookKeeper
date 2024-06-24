class ApplicationController < ActionController::Base
    before_action :set_current_user
    helper_method :current_user
    

    def set_current_user
        @current_user = User.find_by(id: session[:user_id])
    end
    
    def authenticate_user
        if @current_user == nil
            flash[:login] = "ログインしてください"
            redirect_to("/login")
        end
    end

    def forbid_login_user
        if @current_user
            flash[:success] = "すでにログインしています"
            redirect_to("/book/index")
        end
    end

    private

    def current_user
        @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end

    def authenticate_user!
        redirect_to login_path, alert: "ログインしてください" unless current_user
    end
    
end