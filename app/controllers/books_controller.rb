class BooksController < ApplicationController
    before_action :authenticate_user
    
    
  
    def edit
      @book = Book.find_by(id: params[:id])
    end
  
    def update
      @book = Book.find(params[:id])
    
      if @book.update(book_params)
        flash[:success] = "書籍情報が更新されました"
        redirect_to books_path
      else
        flash[:error] = @book.errors.full_messages.join(", ")
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
      # 検索機能
      if params[:search].present?
        @books = @books.where("title LIKE ? OR author LIKE ?", "%#{params[:search]}%", "%#{params[:search]}%")
      end
  
      # 並べ替え機能
      if params[:sort] == 'title'
        @books = @books.order('title ASC')
      elsif params[:sort] == 'created_at'
        @books = @books.order('created_at DESC')
      elsif params[:sort] == 'updated_at'
        @books = @books.order('updated_at DESC')
      end
    end
  
    def show
      @book = Book.find(params[:id])
    end

    def new
      @book = Book.new
    end
  
    def create
      @book = current_user.books.build(book_params)
      error_messages = []
    
      error_messages << "タイトルが空欄です" if @book.title.blank?
      error_messages << "著者が空欄です" if @book.author.blank?
      error_messages << "出版社が空欄です" if @book.publisher.blank?
      error_messages << "出版日が空欄です" if @book.date.blank?
    
      if error_messages.any?
        flash[:error] = error_messages.join(", ") # エラーメッセージをカンマ区切りで連結
        render("/book/add")
        return
      end
    
      if @book.save
        flash[:success] = "書籍が正常に登録されました"
        redirect_to books_path
      end
    end
    
  
    private
  
    def book_params
      params.require(:book).permit(:title, :author, :publisher, :genre, :date, :book_image)
    end
  end  