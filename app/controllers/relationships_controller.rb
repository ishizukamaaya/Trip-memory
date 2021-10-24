class RelationshipsController < ApplicationController

  def create
    @user = User.find(params[:user_id])
    current_user.follow(params[:user_id])
  end

  def destroy
    @user = User.find(params[:user_id])
    current_user.unfollow(params[:user_id])
  end

  #followしてる人を表示
  def followings
    @user = User.find(params[:user_id])
    @users = @user.followings.page(params[:page]).per(10) #1ページに10件表示
  end

  def followers #followされている人を表示
    @user = User.find(params[:user_id])
    @users = @user.followers.page(params[:page]).per(10)
  end

end
