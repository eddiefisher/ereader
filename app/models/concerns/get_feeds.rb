module GetFeeds
  extend ActiveSupport::Concern

  module ClassMethods
    def update_from_feed(channel)
      feed = Feedjira::Feed.fetch_and_parse(channel.xml_url)
      return if feed.is_a?(Fixnum)
      add_entries(feed.entries, channel) if channel.feed_changed?(feed)
    end

    def add_entries(entries, channel)
      entries.each do |entry|
        published = entry.published || Time.now

        create!(
          name:         entry.title,
          summary:      entry.summary,
          url:          prepare_url(entry.url),
          published_at: published,
          guid:         entry.id,
          channel_id:   channel.id
        ) unless exists?(guid: entry.id)
      end
    end

    def prepare_url(url)
      return url unless url.include?('utm_')

      uri = URI(url)
      uri_params = CGI.parse(uri.query)
      blacklist = %w(utm_source utm_medium utm_campaign)
      uri.query = URI.encode_www_form(uri_params.select { |h, _| !blacklist.include?(h) })
      uri.to_s
    end
  end
end
