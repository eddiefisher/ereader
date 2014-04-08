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
    source = open(self.url, "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_2) AppleWebKit/537.75.14 (KHTML, like Gecko) Version/7.0.3 Safari/537.75.14").read

    content = get_filtered_content source

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

  def get_filtered_content source
    if ['http://habrahabr.ru/rss/hubs/', 'http://habrahabr.ru/rss/new/'].include?(self.channel.xml_url)
      get_habrahabra_content source
    else
      get_readability_content source
    end
  end

  def get_readability_content source
    results = Readability::Document.new(source,
                              tags: %w[div p br img a h1 h2 h3 h4 h5 h6 strong code pre span b i blockquote ul ol li dd dt],
                              attributes: %w[src href class],
                              remove_empty_nodes: false,
                              remove_unlikely_candidates: false)
    results.content
  end

  def get_habrahabra_content source
    results = Nokogiri::HTML(source)
    content = results.css('.content.html_format').to_s
    if content.blank?
      content = results.css('#reg-wrapper').to_s
    end
    content
  end

end
