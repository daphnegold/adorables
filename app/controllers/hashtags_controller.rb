class HashtagsController < ApplicationController
  def index
    @hashtags = Hashtag.all
    if params[:search]
      @hashtags = Hashtag.search(params[:search])
    else
      @hashtags = Hashtag.all
    end
  end

  def show
    @hashtag = Hashtag.find(params[:id])
  end
end
