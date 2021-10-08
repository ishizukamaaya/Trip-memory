class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    @post_images = @user.post_images
    @post_images = PostImage.page(params[:page]).reverse_order
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update(user_params)
    redirect_to user_path(@user)
  end

  def destroy
  end

  def unsubscribe
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

end
