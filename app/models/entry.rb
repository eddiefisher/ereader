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

  def source
    open(self.url, "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_2) AppleWebKit/537.75.14 (KHTML, like Gecko) Version/7.0.3 Safari/537.75.14").read
  end

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

  def get_readability_content
    results = Readability::Document.new(source,
                              tags: %w[div p br img a h1 h2 h3 h4 h5 h6 strong code pre span b i blockquote ul ol li dd dt],
                              attributes: %w[src href class],
                              remove_empty_nodes: false,
                              remove_unlikely_candidates: false)
    results.content
  end

  def get_filtered_content
    path = self.channel.xml_url
    content = ''
    if path.include?('habrahabr.ru')
      content = get_habrahabra_content
    elsif path.include?('livejournal.com')
      content = get_livejournal_content
    elsif path.include?('xkcd.com')
      content = get_xkcd_com_content
    elsif path.include?('opennet.ru')
      content = cp1251_to_utf8 get_readability_content
    else
      content = get_readability_content
    end
    content
  end

  def get_habrahabra_content
    results = Nokogiri::HTML(source)
    content = results.css('.content.html_format').to_s || results.css('#reg-wrapper').to_s if content.blank?
  end

  def get_livejournal_content
    results = Nokogiri::HTML(source)
    results.css('.b-singlepost-body').to_s
  end

  def get_xkcd_com_content
    results = Nokogiri::HTML(source)
    results.css('#comic').to_s
  end

  def cp1251_to_utf8 data
    # data.force_encoding("koi8-r").encode("utf8", undef: :replace)
    Iconv.conv('UTF-8//IGNORE', 'KOI8-R', data)
  end
end
