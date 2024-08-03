class BooksController < ApplicationController
  before_action :authenticate_user!
    def new
      @book = Book.new
    end
  
    def create
      # buildメソッドで、ログインユーザーに紐づけられた書籍を作成する
      @book = current_user.books.build(book_params)
  
      # invaild?メソッドで、新規作成しようとした書籍情報がバリデーションに違反している場合、custom_error_messagesメソッドのエラーメッセージを表示させる
      if @book.invalid?
        flash.now[:error] = @book.errors.full_messages.join(", ")
        render :new
        return
      end
  
      if @book.save
        flash[:success] = "書籍が正常に登録されました"
        redirect_to books_path
      else
        flash.now[:error] = "書籍の登録に失敗しました"
        render :new
      end
    end
    
    def edit
      @book = Book.find_by(id: params[:id])
    end
  
    def update
      @book = Book.find_by(id: params[:id])
      
      unless @book
        flash[:error] = "指定された書籍が見つかりません"
        redirect_to books_path and return
      end
      
      @book.assign_attributes(book_params)
      
      if @book.invalid?
        flash.now[:error] = @book.errors.full_messages.join(", ")
        render :edit
        return
      end
      
      if @book.update(book_params)
        flash[:success] = "書籍情報が更新されました"
        redirect_to books_path
      else
        flash[:error] = "更新に失敗しました"
        render :edit
      end
    end

    
    def destroy
      @book = Book.find(params[:id])
      if @book.user_id == current_user.id
        @book.destroy
        flash[:success] = "書籍を削除しました"
      else
        flash[:alert] = "書籍の削除に失敗しました"
      end
      redirect_to books_path
    end
  
    def index
      @books = current_user.books
    
      # 検索欄にキーワードを入力したら実行する
      if params[:search].present?
        # keywordに検索欄に入力されたキーワードをワイルドカードをつけて部分一致検索できるように格納する
        # 「ActiveRecord::Base.sanitize_sql_like(params[:search])」でキーワードに対してSQLインジェクションを防ぐためのエスケープ処理を行う
        keyword = "%#{ActiveRecord::Base.sanitize_sql_like(params[:search])}%"
        # whereメソッドを使い、keywordをもとにタイトル・著者・出版社の部分一致検索ができるようにSQLクエリを構築する
        @books = @books.where("title LIKE ? OR author LIKE ? OR publisher LIKE ?", keyword, keyword, keyword)
      end
    
      # ジャンルでの検索
      if params[:genre].present?
        # whereメソッドを使い、検索フォームのラジオボタンで選択されたジャンルをもとに検索する
        @books = @books.where(genre: params[:genre])
      end
    
      # ラジオボタンで選択された項目をもとに分岐させる
      # 登録書籍をタイトルの昇順で並び替える
      if params[:sort] == 'title'
        @books = @books.order('title ASC')

      # 登録書籍を出版日の降順で並び替える
      elsif params[:sort] == 'date_desc'
        @books = @books.order('date DESC')
      
      # 登録書籍を出版日の昇順で並び替える
      elsif params[:sort] == 'date_asc'
        @books = @books.order('date ASC')
      end
    end
  
    def show
      @book = Book.find_by(id: params[:id])
    end
  
    private
  
    # require(:book)で:bookというキーが存在することを確認し、permitメソッドで送信するカラムを制限する
    def book_params
      params.require(:book).permit(:title, :author, :publisher, :genre, :date, :book_image)
    end

    # 設定したバリデーションエラーに対するカスタムエラーメッセージを生成する
    def custom_error_messages(record)
      error_messages = []
    
      record.errors.each do |attribute, message|
        error_key = "activerecord.errors.models.book.attributes.#{attribute}.#{message}"
        error_message = I18n.t(error_key, default: message)
        error_messages << error_message
      end
    
      error_messages
    end
  end