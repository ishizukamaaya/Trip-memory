class PostImagesController < ApplicationController

  def new
    @post_image = PostImage.new
  end

  def create
    @post_image = PostImage.new(post_image_params)
    @post_image.user_id = current_user.id
    @post_image.save
    redirect_to post_images_path
  end

  def index
    @post_images = PostImage.page(params[:page]).reverse_order
    @ranks = PostImage.joins(:favorites).where(favorites: { created_at:Time.current.all_week}).group(:id).order("count(*) desc")#今週、月曜から日曜のいいねランキング
  end

  def show
    @post_image = PostImage.find(params[:id])
    @user = @post_image.user
    @comment = Comment.new
  end

  def edit
    @post_image = PostImage.find(params[:id])
  end

  def update
    @post_image = PostImage.find(params[:id])
    @post_image.update(post_image_params)
    redirect_to post_image_path(@post_image)
  end

  def destroy
    @post_image = PostImage.find(params[:id])
    @post_image.destroy
    redirect_to post_images_path
  end

  private

  def post_image_params
    params.require(:post_image).permit(:title,:image,:introduction,:evaluation)
  end
end


