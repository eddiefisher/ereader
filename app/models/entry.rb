class Entry < ActiveRecord::Base
  include GetFeeds
  include GetEntryBody

  belongs_to :channel

  scope :ordering, ->{ order(published_at: :desc) }

  def self.batch
    %w{read unread flag unflag star unstar}
  end
end
