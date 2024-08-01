class PostsController < ApplicationController
  before_action :authenticate_user!
  def index
    # 「includes(:user)」で投稿と関連するユーザーを一緒に読み込む。これにより、N+1問題を回避する
    # 投稿を更新日時の降順で表示する
    @posts = Post.includes(:user).order(updated_at: :desc)
  
    if params[:search].present?
      # ワイルドカードをつけて、入力されたキーワードで部分一致検索ができるようする
      # 「ActiveRecord::Base.sanitize_sql_like(params[:search])」でキーワードに対してSQLインジェクションを防ぐためのエスケープ処理を行う
      search_term = "%#{ActiveRecord::Base.sanitize_sql_like(params[:search])}%"

      # whereメソッドを使って、投稿のタイトル・内容をもとに部分一致検索を行うようなSQLクエリを構築する
      @posts = @posts.where("title LIKE ? OR content LIKE ?", search_term, search_term)
    end
  
    if params[:genre].present?
      # whereメソッドでラジオボタンで選択されたジャンルをもとに検索するようにSQLクエリを構築する
      @posts = @posts.where(genre: params[:genre])
    end
  end

  def show
    @post = Post.find_by(id: params[:id])
    @user = @post.user
  end

  def new
    @post = Post.new
    @post.title = params[:book_title] if params[:book_title].present?
    @post.genre = params[:book_genre] if params[:book_genre].present?
  end

  def create
    # buildメソッドでログインユーザに紐づけられた投稿を作成する
    @post = current_user.posts.build(post_params)
  
    if @post.save
      flash[:notice] = "感想を投稿しました"
      redirect_to posts_path
    elsif @post.content.blank?
      flash.now[:notice] = "タイトルまたは感想が空白です"
      render :new
    else
      flash.now[:notice] = "感想の投稿に失敗しました"
      render :new
    end
  end

  def edit
    @post = Post.find_by(id: params[:id])
    unless @post.user == current_user
      redirect_to posts_path, alert: "他のユーザーの投稿は編集できません"
    end
  end
  
  def update
    @post = Post.find_by(id: params[:id])
    
    unless @post
      flash[:error] = "指定された投稿が見つかりません"
      redirect_to posts_path and return
    end
  
    if @post.update(post_params)
      flash[:success] = "感想を編集しました"
      redirect_to post_path(@post)
    elsif @post.content.blank?
      flash.now[:notice] = "タイトルまたは感想が空白です"
      render :edit
    else
      flash[:error] = "感想の編集に失敗しました"
      render :edit
    end
  end
    
  def destroy
    @post = Post.find_by(id: params[:id])
    if @post.user == current_user
      @post.destroy
      flash[:notice] = "感想を削除しました"
    else
      flash[:alert] = "他のユーザーの投稿は削除できません"
    end
    redirect_to posts_path
  end  

  private

  # requireメソッドで「:post」というキーがあることを確認し、permitメソッドで送信するカラムを制限する
  def post_params
    params.require(:post).permit(:title, :genre, :content)
  end
end