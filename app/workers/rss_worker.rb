class RssWorker
  include Sidekiq::Worker
  sidekiq_options queue: "high"
  # sidekiq_options retry: false
  
  def perform
    logger.info "Sidekiq::Worker started"
    Entry.update_from_feed('http://habrahabr.ru/rss/hubs/')
  end
end
