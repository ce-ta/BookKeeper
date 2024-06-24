class PostsController < ApplicationController
    before_action :authenticate_user
    
    def index
        @posts = Post.includes(:user).order(updated_at: :desc)
    end
  
    def show
        @post = Post.find_by(id: params[:id])
        @user = @post.user
    end

    def new
        @post = Post.new
    end
    
    def create
      @post = Post.new(post_params)
      @post.user_id = @current_user.id
    
      if @post.save
        flash[:notice] = "感想を投稿しました"
        redirect_to posts_path
      else
        flash.now[:notice] = "タイトルまたは感想が空白です"
        render :new
      end
    end  

    def edit
        @post = Post.find_by(id: params[:id])
        if @post.user != current_user
          redirect_to posts_path, alert: "他のユーザーの投稿は編集できません"
        end
    end
      
    def update
      @post = Post.find_by(id: params[:id])
      @post.title = params[:post][:title]
      @post.content = params[:post][:content]
      
      if @post.save
        flash[:notice] = "投稿を編集しました"
        redirect_to posts_path
      else
        puts @post.errors.full_messages # エラーメッセージを表示
        render("posts/edit")
      end
    end    
      
    def destroy
      @post = Post.find_by(id: params[:id])
      if @post.user == current_user
        @post.destroy
        flash[:notice] = "投稿を削除しました"
      else
        flash[:alert] = "他のユーザーの投稿は削除できません"
      end
      redirect_to posts_path
    end    

    def post_params
      params.require(:post).permit(:title, :content)
    end

end