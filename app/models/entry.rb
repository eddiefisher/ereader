class Entry < ActiveRecord::Base
  include GetFeeds
  include GetEntryBody
  searchkick callbacks: false

  belongs_to :channel

  scope :ordering,  -> { order(published_at: :desc) }
  scope :entries, ->(q, ids, page, per) { search q, where: {channel_id: ids}, order: {published_at: :desc}, page: page, per_page: per }

  def self.batch
    %w(read unread flag unflag star unstar)
  end
end
