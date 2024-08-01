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
        error_messages = custom_error_messages(@book)
        flash.now[:error] = error_messages.join(", ")
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
      
      # invaild?メソッドで、更新しようとした書籍情報がバリデーションに違反している場合、custom_error_messagesメソッドのエラーメッセージを表示させる
      if @book.invalid?
        error_messages = custom_error_messages(@book)
        flash[:error] = error_messages.join(", ")
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

      # attributeはエラーが発生した属性名、messageはその属性に対するエラーメッセージが入る
      record.errors.each do |attribute, message|
        case attribute
        when :title
          if message == "can't be blank"
            error_messages << "タイトルが空欄です"
          elsif message == "is too long (maximum is 30 characters)"
            error_messages << "タイトルは30文字以内で入力してください"
          end
        when :author
          if message == "can't be blank"
            error_messages << "著者が空欄です"
          elsif message == "is too long (maximum is 20 characters)"
            error_messages << "著者は20文字以内で入力してください"
          end
        when :publisher
          if message == "can't be blank"
            error_messages << "出版社が空欄です"
          elsif message == "is too long (maximum is 10 characters)"
            error_messages << "出版社は10文字以内で入力してください"
          end
        when :genre
          if message == "can't be blank"
            error_messages << "ジャンルが未選択です"
          end
        when :date
          if message == "can't be blank"
            error_messages << "出版日が空欄です"
          end
      end
      
      # 配列を返す
      error_messages
    end
  end
  end  