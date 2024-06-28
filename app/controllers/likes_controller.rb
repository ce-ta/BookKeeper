class LikesController < ApplicationController
    before_action :find_likeable
  
    def create
      @like = @likeable.likes.build(user: current_user)
  
      respond_to do |format|
        if @like.save
          format.html { redirect_to @likeable }
          format.js   # create.js.erb をレンダリング
        else
          format.html { redirect_to @likeable, alert: 'いいねに失敗しました。' }
          format.js   { render 'error.js.erb' }
        end
      end
    end
  
    def destroy
      @like = @likeable.likes.find(params[:id])
      @like.destroy
      redirect_to @likeable, notice: 'Unliked successfully.'
    end
  
    private
  
    def find_likeable
      @likeable = if params[:post_id]
                    Post.find(params[:post_id])
                  elsif params[:comment_id]
                    Comment.find(params[:comment_id])
                  end
    end
  end  