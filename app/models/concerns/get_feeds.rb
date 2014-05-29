module GetFeeds
  extend ActiveSupport::Concern

  module ClassMethods
    def update_from_feed(channel)
      feed = Feedjira::Feed.fetch_and_parse(channel.xml_url)
      unless feed.is_a? Fixnum
        if channel.feed_changed?(feed)
          add_entries(feed.entries, channel)
        end
      end
    end

    def add_entries entries, channel
      entries.each do |entry|
        if entry.url.include?('utm_')
          uri = URI(entry.url)
          uri_params = CGI.parse(uri.query)
          blacklist = %w[utm_source utm_medium utm_campaign]
          uri.query = URI.encode_www_form( uri_params.select { |h, key| !blacklist.include?(h) } )
          entry.url = uri.to_s
        else
          entry.url
        end

        published = entry.published || Time.now

        create!(
          :name         => entry.title,
          :summary      => entry.summary,
          :url          => entry.url,
          :published_at => published,
          :guid         => entry.id,
          :channel_id   => channel.id
        ) unless exists?(:guid => entry.id)
      end
    end
  end
end
