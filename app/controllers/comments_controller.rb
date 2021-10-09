class CommentsController < ApplicationController

  def create
    @post_image = PostImage.find(params[:post_image_id])
    comment = current_user.comments.new(comment_params)
    comment.post_image_id = @post_image.id
    comment.save
    redirect_to post_image_path(@post_image)
  end

  def destroy
    Comment.find_by(id:params[:id]).destroy
    redirect_to post_image_path(params[:post_image_id])
  end

  private

  def comment_params
    params.require(:comment).permit(:comment)
  end

end
