class Entry < ActiveRecord::Base
  include GetFeeds
  include GetEntryBody

  belongs_to :channel

  scope :ordering,  -> { order(published_at: :desc) }
  scope :entries, ->(ids, page) { where(channel_id: ids).ordering.page(page) }

  def self.batch
    %w(read unread flag unflag star unstar)
  end
end
