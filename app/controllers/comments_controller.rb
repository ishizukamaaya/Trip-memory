class CommentsController < ApplicationController

  def create
    @post_image = PostImage.find(params[:post_image_id])
    @comment = Comment.new(comment_params)
    @comment.post_image_id = @post_image.id
    @comment.user_id = current_user.id
    @comment.save
  end

  def destroy
    @post_image = PostImage.find(params[:post_image_id])
    @comment = @post_image.comments.find(params[:id])
    @comment.destroy
  end

  private

  def comment_params
    params.require(:comment).permit(:comment)
  end

end
