class CommentsController < ApplicationController
  before_filter :authenticate, only: [:create]

  def new
    unless session[:user_id].nil?
      @comment = Comment.new
      @action = "create"
    else
      redirect_to root_path, notice: "Please login."
    end
  end

  def create
    Comment.create(comment_params)
    Comment.last.update(user_id: session[:user_id])
    tags = comment_params[:comment].scan(/\B#\w+/)
    link = Link.find(params[:link_id])
    Hashtag.add_hashtags(tags, link) unless tags.empty?
    redirect_to links_path(anchor: "link_#{params[:link_id]}")
  end

  def destroy
    comment = Comment.find(params[:id])
    comment.destroy

    redirect_to links_path
  end

  private

  def comment_params
    comment = params.require(:comment).permit(:comment)
    comment.merge(params.permit(:link_id))
  end

  def authenticate
    redirect_to root_url, notice: "Please login." if current_user.nil?
  end
end
