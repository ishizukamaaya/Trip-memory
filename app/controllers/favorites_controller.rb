class FavoritesController < ApplicationController

  def create
    @post_image = PostImage.find(params[:post_image_id])
    favorite = current_user.favorites.new(post_image_id: @post_image.id)
    favorite.save
  end

  def destroy
    @post_image = PostImage.find(params[:post_image_id])
    favorite = current_user.favorites.find_by(post_image_id: @post_image.id)
    favorite.destroy
  end

  def favorite_list
    favorites = Favorite.where(user_id: current_user.id).pluck(:post_image_id) # ログイン中のユーザーのいいねのpost_image_idを取得
    @favorite_list = PostImage.find(favorites) #いいね済のレコードを取得
    @favorite_list = Kaminari.paginate_array(@favorite_list).page(params[:page]).per(6) #1ページに6件表示
    @tag_list = Tag.joins(:post_image_tags).distinct #結合して重複のないデータを取得(1つ以上データがあれば)
  end

end
