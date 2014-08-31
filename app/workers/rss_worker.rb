class RssWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { hourly }

  def perform
    Channel.where(locked: false).each do |channel|
      Entry.update_from_feed(channel)
    end
  end
end
