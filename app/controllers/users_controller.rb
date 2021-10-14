class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:update, :edit]

  def show
    @user = User.find(params[:id])
    @tag_list = Tag.all

    if params[:sort].nil? #もし、sortが空だったら
      @post_images = @user.post_images.page(params[:page]).per(6).order(created_at: :desc) #新着順
    else
      @post_images = @user.post_images.page(params[:page]).per(6).order(params[:sort]) #そうじゃなかったらsort順にする
    end
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
    post_images = @user.post_images  #=> [{post_image_id: 3, XXX....}, {post_image_id: 4, XXX....}]
    if(post_images.present?)
      post_images.each do |post_image|
        post_image_tags = post_image.post_image_tags

        if(post_image_tags.present?)
          post_image_tags.each do |post_image_tag|
            target = Tag.find_by(id: post_image_tag.tag_id)
            target.destroy
          end
        end
        post_image_tags.destroy #タグ一覧からも削除
      end
    end
    @user.destroy
    redirect_to :root
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
