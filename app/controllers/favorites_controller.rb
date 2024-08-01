class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    # ログインユーザーに関連する新しいfavoriteオブジェクトを作成する。「post: @post」で対象の投稿を設定する
    favorite = current_user.favorites.new(post: @post)

    # リクエストされたフォーマットに応じたレスポンスを行う
    respond_to do |format|
      if favorite.save
        # HTMLフォーマットがリクエストされた場合、保存後に投稿詳細ページに飛ぶ
        format.html { redirect_to @post }

        # JavaScriptフォーマットがリクエストされた場合、"create.js.erb"を返す
        format.js
      else
        format.html { redirect_to @post, alert: 'いいねの保存に失敗しました' }
      end
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
     # ログインユーザーに関連する新しいfavoriteオブジェクトを作成する。「post: @post」で対象の投稿を設定する
    favorite = current_user.favorites.find_by(post: @post)

    # リクエストされたフォーマットに応じたレスポンスを行う
    respond_to do |format|
      if favorite.destroy
        # HTMLフォーマットがリクエストされた場合、削除後に投稿詳細ページに飛ぶ
        format.html { redirect_to @post }

        # JavaScriptフォーマットがリクエストされた場合、"destroy.js.erb"を返す
        format.js
      else
        format.html { redirect_to @post, alert: 'いいねの取り消しに失敗しました' }
      end
    end
  end
end