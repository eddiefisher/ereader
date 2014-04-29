class Entry < ActiveRecord::Base
  include EntryReadable
  include EntryFlagable
  include EntryStarable

  belongs_to :channel
  default_scope ->{ order(published_at: :desc) }

  def self.batch
    %w{read unread flag unflag star unstar}
  end

  def self.update_from_feed(channel)
    feed = Feedjira::Feed.fetch_and_parse(channel.xml_url)
    unless feed.is_a? Fixnum
      add_entries(feed.entries, channel)
    end
  end

  def get_body
    content = get_filtered_content

    update_attributes(body: content)
    update_attributes(summary: content) if self.summary.blank?
  end

  private

  def self.add_entries entries, channel
    entries.each do |entry|
      published = entry.published || Time.now

      uri = ''
      if entry.url.include?('utm_')
        uri = URI(entry.url)
        uri_params = CGI.parse(uri.query)
        blacklist = %w[utm_source utm_medium utm_campaign]
        uri.query = URI.encode_www_form( uri_params.select { |h, key| !blacklist.include?(h) } )
        url = uri.to_s
      else
        url = entry.url
      end

      create!(
        :name         => entry.title,
        :summary      => entry.summary,
        :url          => url,
        :published_at => published,
        :guid         => entry.id,
        :channel_id   => channel.id
      ) unless exists?(:guid => entry.id)
    end
  end

  def source
    open(self.url, "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_2) AppleWebKit/537.75.14 (KHTML, like Gecko) Version/7.0.3 Safari/537.75.14").read
  end

  def get_filtered_content
    path = self.channel.xml_url
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
