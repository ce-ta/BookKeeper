class CommentsController < ApplicationController
  def new
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build
  end

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      flash[:success] = "コメントを投稿しました"
      redirect_to "/posts/#{@post.id}"
    else
      flash.now[:error] = "コメントの投稿に失敗しました"
      render :new
    end
  end

  def edit
    @comment = Comment.find_by(id: params[:id])
    post_id = @comment.post_id
    if @comment.user != current_user
      flash[:error] = "他のユーザーのコメントは編集できません"
    end
  end

  def update
    @comment = Comment.find_by(id: params[:id])
    post_id = @comment.post_id

    # コメントの更新
    if @comment.update(comment_params)
      flash[:success] = "コメントを編集しました"
      redirect_to "/posts/#{@post.id}"
    elsif @comment.errors[:body].any? && @comment.errors[:body].first.include?("is too long")
      flash[:error] = "コメントは140文字以内で入力してください"
    elsif @comment.errors[:body].any?
      flash[:error] = "コメントが空白です"
    else
      flash[:error] = "コメントの編集に失敗しました"
      render :edit
    end
  end
  

  def destroy
    @comment = Comment.find_by(id: params[:id])
    if @comment.user == current_user
      @comment.destroy
      flash[:success] = "コメントを削除しました"
      redirect_to posts_path
    else
      flash[:error] = "他のユーザーのコメントは削除できません"
      redirect_to posts_path
    end
  end
    
    private
    
    def comment_params
        params.require(:comment).permit(:body)
    end
end
