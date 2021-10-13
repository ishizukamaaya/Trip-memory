class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:update, :edit]

  def show
    @user = User.find(params[:id])
    @post_images = PostImage.page(params[:page]).per(6).order(params[:sort])
    @tag_list = Tag.all
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user)
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    @post_image_tag_all = @post_image.post_image_tags.all #全てのtag取得
    tag_ids = Array.new
    @post_image_tag_all.each do |tag| #tagを取り出す
      tag_ids.push(tag.tag_id)
    end
    @user.destroy
    tag_ids.each do |tag_id|
      if PostImageTag.where(tag_id: tag_id).count == 0 #tagが０だったらtagをdestroy
        Tag.find(tag_id).destroy
      end
    redirect_to :root
    end
  end

  def unsubscribe
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  #userがログインuserdではなかったらログインuserのページへ
  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end

end
