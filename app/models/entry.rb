class Entry < ActiveRecord::Base
  belongs_to :channel
  default_scope ->{ order(published_at: :desc) }

  def get_body
    content = get_filtered_content

    update_attributes(body: content)
    update_attributes(summary: content) if summary.blank?
  end

  class << self
    def batch
      %w{read unread flag unflag star unstar}
    end

    def update_from_feed(channel)
      feed = Feedjira::Feed.fetch_and_parse(channel.xml_url)
      unless feed.is_a? Fixnum
        if channel.feed_changed?(feed)
          add_entries(feed.entries, channel)
        end
      end
    end

    private

    def add_entries entries, channel
      entries.each do |entry|
        published = entry.published || Time.now

        create!(
          :name         => entry.title,
          :summary      => entry.summary,
          :url          => entry.cleaned_url,
          :published_at => published,
          :guid         => entry.id,
          :channel_id   => channel.id
        ) unless exists?(:guid => entry.id)
      end
    end
  end

  private

  def cleaned_url
    if entry.url.include?('utm_')
      uri = URI(entry.url)
      uri_params = CGI.parse(uri.query)
      blacklist = %w[utm_source utm_medium utm_campaign]
      uri.query = URI.encode_www_form( uri_params.select { |h, key| !blacklist.include?(h) } )
      uri.to_s
    else
      entry.url
    end
  end

  def source
    open(url, "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_2) AppleWebKit/537.75.14 (KHTML, like Gecko) Version/7.0.3 Safari/537.75.14").read
  end

  def get_filtered_content
    path = channel.xml_url
    content = ''
    if path.include?('habrahabr.ru')
      content = ContentFactory.new(source, [:habrahabr, :sanitize])
    elsif path.include?('livejournal.com')
      content = ContentFactory.new(source, [:livejournal, :sanitize])
    elsif path.include?('xkcd.com')
      content = ContentFactory.new(source, [:xkcd, :sanitize])
    elsif path.include?('seasonvar.ru')
      content = ContentFactory.new(source, [:seasonvar, :sanitize])
    elsif path.include?('opennet.ru')
      content = ContentFactory.new(source, [:opennet, :sanitize])
    else
      content = ContentFactory.new(source, [:readabilityfilter])
    end

    content.result
  end
end
