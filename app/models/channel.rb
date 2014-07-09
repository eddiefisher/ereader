class Channel < ActiveRecord::Base
  has_many :entries
  has_many :users
  has_many :users, through: :users

  scope :other, ->(ids) { where.not(id: ids) }

  def feed_changed?(feed)
    sha = Digest::SHA2.hexdigest(feed.entries.map{ |f| f.title }.join(' '))
    if last_feed_sha == sha
      false
    else
      update_attributes(last_feed_sha: sha)
      true
    end
  end
end
