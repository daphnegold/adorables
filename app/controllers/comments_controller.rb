class CommentsController < ApplicationController
  # before_filter :authenticate, only: [:create]

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
    Comment.last.update(user_id: 1) #session[:user_id])
    tags = comment_params[:comment].scan(/\B#\w+/)
    link = Link.find(params[:link_id])
    unless tags.empty?
      tags.each do |tag|
        existing_hashtag = Hashtag.find_by_tag(tag)
        if existing_hashtag.nil?
          new_hashtag = Hashtag.create(tag: tag)
          new_hashtag.links << link
        else
          existing_hashtag.links << link unless link.hashtags.include?(existing_hashtag)
        end
      end
    end
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
