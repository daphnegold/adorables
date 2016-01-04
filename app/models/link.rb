class Link < ActiveRecord::Base
  belongs_to :user
  has_many :comments
  has_many :votes
  has_and_belongs_to_many :hashtags

  validates :url, format: {with: /\.(png|jpg|gif|jpeg)\Z/i}

  after_destroy do
    Vote.destroy_all(link_id: self.id)
    Comment.destroy_all(link_id: self.id)
  end

  def total_votes
    self.votes.inject(0) { |sum, vote| sum + vote.value }
  end
end
