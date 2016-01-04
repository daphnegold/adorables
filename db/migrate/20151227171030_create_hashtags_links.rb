class CreateHashtagsLinks < ActiveRecord::Migration
  def change
    create_table :hashtags_links do |t|
      t.belongs_to :hashtag, index: true
      t.belongs_to :link, index: true
    end
  end
end
