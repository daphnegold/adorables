module CommentsHelper
  def transform_hashtags_to_links(comment)
    tags = comment.scan(/\B#\w+/)
    tags.each do |tag|
      hashtag = Hashtag.find_by_tag(tag)
      url = hashtag_path(hashtag.id)
      comment.gsub!(tag, "#{link_to tag, url}")
    end
    return comment
  end
end
