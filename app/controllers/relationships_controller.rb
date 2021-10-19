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
    user = User.find(params[:user_id])
    @users = user.followings
  end

  def followers #followされている人を表示
    user = User.find(params[:user_id])
    @users = user.followers
  end

end
