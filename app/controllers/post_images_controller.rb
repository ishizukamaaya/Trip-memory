class PostImagesController < ApplicationController

  def new
    @post_image = PostImage.new
  end

  def create
    @post_image = PostImage.new(post_image_params)
    @post_image.user_id = current_user.id
    if @post_image.save
      tag_list = tag_params[:name].split(',')
      @post_image.save_tags(tag_list)
      redirect_to post_image_path(@post_image)
    else
      render :new
    end
  end

  def index
    @post_images = PostImage.page(params[:page]).reverse_order
    @ranks = PostImage.find(Favorite.group(:post_image_id).where(created_at: Time.current.all_week).order('count(post_image_id) desc').limit(3).pluck(:post_image_id)) #今週、月曜から日曜日のいいねランキング
    @tag_list = Tag.all
  end

  def show
    @post_image = PostImage.find(params[:id])
    @user = @post_image.user
    @comment = Comment.new
    @post_image_tags = @post_image.tags
  end

  def edit
    @post_image = PostImage.find(params[:id])
    @tag_list = @post_image.tags.pluck(:name).join(',')
  end

  def update
    @post_image = PostImage.find(params[:id])
    tag_list = params[:post_image][:name].split(',')
    @post_image.update(post_image_params)
    @post_image.save_tags(tag_list)
    redirect_to post_image_path(@post_image)
  end

  def destroy
    @post_image = PostImage.find(params[:id])
    @post_image.destroy
    redirect_to post_images_path
  end

  def search_tag
    @tag_list = Tag.all
    @tag = Tag.find(params[:tag_id])
    @post_images = @tag.post_images
  end

  private

  def post_image_params
    params.require(:post_image).permit(:title,:image,:introduction,:evaluation)
  end

  def tag_params
    params.require(:post_image).permit(:name)
  end

end


