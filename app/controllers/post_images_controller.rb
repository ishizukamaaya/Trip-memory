class PostImagesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

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
    @post_images = PostImage.page(params[:page]).per(6).order(params[:sort])
    @ranks = PostImage.find(Favorite.group(:post_image_id).where(created_at: Time.current.all_week).order('count(post_image_id) desc').limit(3).pluck(:post_image_id)) #今週、月曜から日曜日のいいねランキング
    @tag_list = Tag.all
  end

  def show
    @post_image = PostImage.find(params[:id])
    @user = @post_image.user
    @comment = Comment.new
    @post_image_tags = @post_image.tags
    @tag_list = Tag.all
  end

  def edit
    @post_image = PostImage.find(params[:id])
    @tag_list = @post_image.tags.pluck(:name).join(',')
    if @post_image.user == current_user
      render :edit
    else
      redirect_to post_images_path
    end
  end

  def update
    @post_image = PostImage.find(params[:id])
    tag_list = params[:post_image][:name].split(',')
    @post_image_tag_all = @post_image.post_image_tags.all #全てのtag取得
    tag_ids = Array.new
    @post_image_tag_all.each do |tag| #tagを取り出す
      tag_ids.push(tag.tag_id)
    end
    if @post_image.update(post_image_params)
      @post_image.save_tags(tag_list)
      tag_ids.each do |tag_id|
        if PostImageTag.where(tag_id: tag_id).count == 0 #tagが０だったらtagをdestroy
          Tag.find(tag_id).destroy
        end
    end
      redirect_to post_image_path(@post_image)
    else
      render :edit
    end
  end

  def destroy
    @post_image = PostImage.find(params[:id])
    @post_image_tag_all = @post_image.post_image_tags.all
    tag_ids = Array.new
    @post_image_tag_all.each do |tag|
      #idを探して箱に入れる
      tag_ids.push(tag.tag_id)
    end
    @post_image.destroy
    tag_ids.each do |tag_id|
      if PostImageTag.where(tag_id: tag_id).count == 0 #tagが０だったらtagをdestroy
        Tag.find(tag_id).destroy
      end
    end
    redirect_to post_images_path
  end

  def search_tag
    @tag_list = Tag.all
    @tag = Tag.find(params[:tag_id])
    @post_images = @tag.post_images.page(params[:page]).reverse_order
  end

  def search
    @post_images = PostImage.all.search(params[:keyword])
    @tag_list = Tag.all
  end


  private

  def post_image_params
    params.require(:post_image).permit(:title,:image,:introduction,:evaluation)
  end

  def tag_params
    params.require(:post_image).permit(:name)
  end
  
  #ログインuserが投稿したuserではなかったら一覧へ
  def ensure_correct_user
    @post_image = PostImage.find(params[:id])
    unless @post_image.user == current_user
    redirect_to post_images_path
    end
  end

end


