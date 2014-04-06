class Entry < ActiveRecord::Base
  include EntryReadable
  include EntryFlagable
  include EntryStarable

  belongs_to :channel
  default_scope ->{ order(published_at: :desc) }

  def self.update_from_feed(channel)
    feed = Feedjira::Feed.fetch_and_parse(channel.xml_url)
    unless feed.is_a? Fixnum
      add_entries(feed.entries, channel)
    end
  end

  def get_body
    source = open(self.url, "User-Agent" => "Mozilla/5.0 (iPad; CPU OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A5355d Safari/8536.25").read
    @results = Readability::Document.new( source,
                                          tags: %w[div p br img a h1 h2 h3 h4 h5 h6 strong code pre span b i blockquote ul ol li dd dt],
                                          attributes: %w[src href class],
                                          remove_empty_nodes: false,
                                          remove_unlikely_candidates: false)
    content = @results.content

    if ['http://habrahabr.ru/rss/hubs/', 'http://habrahabr.ru/rss/new/'].include?(self.channel.xml_url)
      page = Nokogiri::HTML(@results.content)
      content = page.css('.content.html_format').to_s
    end

    update_attributes(body: content)
    update_attributes(summary: content) if self.summary.blank?
  end

  private

  def self.add_entries entries, channel
    entries.each do |entry|
      create!(
        :name         => entry.title,
        :summary      => entry.summary,
        :url          => entry.url,
        :published_at => entry.published,
        :guid         => entry.id,
        :channel_id   => channel.id
      ) unless exists?(:guid => entry.id)
    end
  end

end
