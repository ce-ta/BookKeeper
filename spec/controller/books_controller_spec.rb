require 'rails_helper'

RSpec.describe BooksController, type: :controller do
  let(:user) { create(:user) }
  let(:book) { create(:book, user: user) }

  before { sign_in user }

  describe "GET #new" do
    it "assigns a new book to @book" do
      get :new
      expect(assigns(:book)).to be_a_new(Book)
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "creates a new book" do
        expect {
          post :create, params: { book: attributes_for(:book) }
        }.to change(Book, :count).by(1)
        expect(flash[:success]).to eq("書籍が正常に登録されました")
        expect(response).to redirect_to(books_path)
      end
    end

    context "with invalid attributes" do
      it "does not create a new book and renders the :new template" do
        expect {
          post :create, params: { book: attributes_for(:book, title: "") }
        }.not_to change(Book, :count)
        expect(flash.now[:error]).to include("タイトルが空欄です")
        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET #edit" do
    it "assigns the requested book to @book" do
      get :edit, params: { id: book.id }
      expect(assigns(:book)).to eq(book)
    end
  end

  describe "PATCH #update" do
    context "with valid attributes" do
      it "updates the requested book" do
        patch :update, params: { id: book.id, book: attributes_for(:book, title: "Updated Title") }
        book.reload
        expect(book.title).to eq("Updated Title")
        expect(flash[:success]).to eq("書籍情報が更新されました")
        expect(response).to redirect_to(books_path)
      end
    end

    context "with invalid attributes" do
      it "does not update the book and renders the :edit template" do
        patch :update, params: { id: book.id, book: attributes_for(:book, title: "") }
        book.reload
        expect(book.title).to eq("Example Book")
        expect(flash.now[:error]).to include("タイトルが空欄です")
        expect(response).to render_template(:edit)
      end
    end

    context "when book is not found" do
      it "redirects to books_path with an error message" do
        patch :update, params: { id: 9999, book: attributes_for(:book) }
        expect(flash[:error]).to eq("指定された書籍が見つかりません")
        expect(response).to redirect_to(books_path)
      end
    end
  end

  describe "DELETE #destroy" do
    context "when user is the owner of the book" do
      it "destroys the book" do
        delete :destroy, params: { id: book.id }
        expect(Book.exists?(book.id)).to be_falsey
        expect(flash[:success]).to eq("書籍を削除しました")
        expect(response).to redirect_to(books_path)
      end
    end

    context "when user is not the owner of the book" do
      let(:other_user) { create(:user) }
      let(:other_book) { create(:book, user: other_user) }

      it "does not destroy the book and redirects with an alert message" do
        delete :destroy, params: { id: other_book.id }
        expect(Book.exists?(other_book.id)).to be_truthy
        expect(flash[:alert]).to eq("書籍の削除に失敗しました")
        expect(response).to redirect_to(books_path)
      end
    end
  end

  describe "GET #index" do
    it "assigns all books of the current user to @books" do
      get :index
      expect(assigns(:books)).to include(book)
    end

    context "with search" do
      it "filters books by title, author, or publisher" do
        get :index, params: { search: book.title }
        expect(assigns(:books)).to include(book)
      end
    end

    context "with genre filter" do
      it "filters books by genre" do
        get :index, params: { genre: book.genre }
        expect(assigns(:books)).to include(book)
      end
    end

    context "with sorting" do
      it "sorts books by title" do
        get :index, params: { sort: 'title' }
        expect(assigns(:books).first).to eq(book)
      end

      it "sorts books by date in descending order" do
        get :index, params: { sort: 'date_desc' }
        expect(assigns(:books).first).to eq(book)
      end

      it "sorts books by date in ascending order" do
        get :index, params: { sort: 'date_asc' }
        expect(assigns(:books).last).to eq(book)
      end
    end
  end

  describe "GET #show" do
    it "assigns the requested book to @book" do
      get :show, params: { id: book.id }
      expect(assigns(:book)).to eq(book)
    end
  end
end