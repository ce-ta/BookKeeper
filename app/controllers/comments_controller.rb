class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:new, :create]
  before_action :set_comment, only: [:edit, :update, :destroy]

  def new
    @comment = @post.comments.build
  end

  def create
    # buildメソッドで投稿に紐づけられたコメントを作成する
    @comment = @post.comments.build(comment_params)

    # コメントとそのコメントを投稿したユーザーを紐づける
    @comment.user = current_user

    if @comment.save
      flash[:success] = "コメントを投稿しました"
      redirect_to post_path(@post)
    else
      flash.now[:error] = "コメントの投稿に失敗しました"
      render :new
    end
  end

  def show
    @comment = Comment.find(params[:id])
    @post = @comment.post
    # リダイレクト後にanchorオプションで、当該コメントの場所に自動でスクロールされる
    redirect_to post_path(@post, anchor: "comment_#{params[:id]}")
  end

  def edit
    # 投稿したユーザー以外が編集しようとした場合にエラーを発生させる
    if @comment.user != current_user
      flash[:error] = "他のユーザーのコメントは編集できません"
      redirect_to comments_path
    end
  end
  
  def update
    # 投稿したユーザー以外が編集しようとした場合にエラーを発生させる
    if @comment.user != current_user
      flash[:error] = "他のユーザーのコメントは編集できません"
      redirect_to comments_path
      return
    end
  
    if @comment.update(comment_params)
      flash[:success] = "コメントを編集しました"
      redirect_to post_path(@comment.post)
    else
      flash.now[:error] = "コメントの編集に失敗しました"
      render :edit
    end
  end

  def destroy
    # 削除するコメントを投稿したユーザーとそのコメントを投稿したユーザーが同じであることを確認する
    if @comment.user == current_user
      @comment.destroy
      flash[:success] = "コメントを削除しました"
    else
      flash[:error] = "他のユーザーのコメントは削除できません"
    end
    redirect_to posts_path
  end

  private

  # コメントと紐づいた投稿のIDを格納する
  def set_post
    @post = Post.find(params[:post_id])
  end

  def set_comment
    @comment = Comment.find_by(id: params[:id])
    unless @comment
      flash[:error] = "指定されたコメントが見つかりません"
      redirect_to posts_path
    end
  end

  # requireメソッドで:commentというキーがあることを確認し、permitメソッドで、送信するカラムを制限する
  def comment_params
    params.require(:comment).permit(:body)
  end
end
