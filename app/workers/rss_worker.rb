class RssWorker
  include Sidekiq::Worker
  sidekiq_options queue: "high"
  sidekiq_options retry: false

  def perform
    Channel.where(locked: false).each do |channel|
      Entry.update_from_feed(channel)
    end
  end
end
