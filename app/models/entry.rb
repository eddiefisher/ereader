class Entry < ActiveRecord::Base
  include GetFeeds
  include GetEntryBody

  belongs_to :channel

  scope :ordering,  -> { order(published_at: :desc) }
  scope :last_news, -> { where('entries.published_at > ?', 1.day.ago) }

  def self.batch
    %w(read unread flag unflag star unstar)
  end
end
