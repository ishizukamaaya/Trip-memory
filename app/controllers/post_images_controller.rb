class PostImagesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def new
    @post_image = PostImage.new
  end

  def create
    @post_image = PostImage.new(post_image_params)
    @post_image.user_id = current_user.id
    tag_list = params[:post_image][:name].split(',')
    if @post_image.save
      @post_image.save_tags(tag_list)
      redirect_to post_image_path(@post_image)
    else
      render :new
    end
  end

  def index
    if params[:sort].nil? #もし、sortが空だったら
      @post_images = PostImage.page(params[:page]).per(3).order(created_at: :desc) #新着順
    else
      @post_images = PostImage.page(params[:page]).per(3).order(params[:sort]) #そうじゃなかったらsort順にする
    end
    @ranks = PostImage.find(Favorite.group(:post_image_id).where(created_at: Time.current.all_week).order('count(post_image_id) desc').limit(3).pluck(:post_image_id)) #今週、月曜から日曜日のいいねランキング
    @tag_list = Tag.joins(:post_image_tags).distinct #結合して重複のないデータを取得(1つ以上データがあれば)
  end

  def show
    @post_image = PostImage.find(params[:id])
    @user = @post_image.user
    @comment = Comment.new
    @post_image_tags = @post_image.tags
    @tag_list = Tag.joins(:post_image_tags).distinct
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
    if @post_image.update(post_image_params)
      @post_image.save_tags(tag_list)
      redirect_to post_image_path(@post_image)
    else
      @tag_list = params[:post_image][:name]
      render :edit
    end
  end

  def destroy
    @post_image = PostImage.find(params[:id])
    @post_image.destroy
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
    params.require(:post_image).permit(:title, :image, :introduction, :evaluation)
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
