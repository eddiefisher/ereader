class RssWorker
  include Sidekiq::Worker
  sidekiq_options queue: "high"
  # sidekiq_options retry: false
  
  def perform
    Channel.all.each do |channel|
      Entry.update_from_feed(channel)
    end
  end
end
