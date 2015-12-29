class Hashtag < ActiveRecord::Base
  has_and_belongs_to_many :links

  def self.add_hashtags(tags, link)
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
end
