class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    @post_images = @user.post_images.page(params[:page]).reverse_order
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
    @user.destroy
    redirect_to :root
  end

  def unsubscribe
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

end
