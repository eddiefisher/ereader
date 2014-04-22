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
    results = Readability::Document.new source, readability_options
    results.content
  end

  def readability_options
    {
      tags: %w[div p br img a h1 h2 h3 h4 h5 h6 strong code pre span b i blockquote ul ol li dd dt],
      attributes: %w[src href align],
      remove_empty_nodes: false,
      remove_unlikely_candidates: false
    }
  end

  def get_filtered_content
    path = self.channel.xml_url
    content = false
    if path.include?('habrahabr.ru')
      content = get_habrahabra_content
    elsif path.include?('livejournal.com')
      content = get_livejournal_content
    elsif path.include?('xkcd.com')
      content = get_xkcd_com_content
    elsif path.include?('seasonvar.ru')
      content = get_seasonvar_content
    end

    if content
      content_filter content
    else
      get_readability_content
    end
  end

  def content_filter content
    content = sanitize(content, readability_options)
    content = content.gsub("<br><blockquote>", "<blockquote>").gsub(/<\/blockquote>(\n)<br>/, "</blockquote>")
    content = content.gsub("<br/><blockquote>", "<blockquote>").gsub("</blockquote><br/>", "</blockquote>")
    content = content.gsub("<a></a>", "")
    content = content.gsub("\t", "  ").gsub("<br><br>", "<br>")
  end

  def get_habrahabra_content
    results = Nokogiri::HTML(source)
    content = results.css('.content.html_format')
    if content.blank?
      content = results.css('#reg-wrapper')
    end
    content
  end

  def get_livejournal_content
    results = Nokogiri::HTML(source)
    results.css('.b-singlepost-body')
  end

  def get_xkcd_com_content
    results = Nokogiri::HTML(source)
    results.css('#comic')
  end

  def get_seasonvar_content
    results = Nokogiri::HTML(source)
    results.css('.rating, script').remove
    results.css('.full-news-1')
  end

  def sanitize(node, options = {})
    node.css("form, object, iframe, embed").each do |elem|
      elem.remove
    end

    node.css("p, a").each do |elem|
      unless elem.css('*').to_a.count > 0
        elem.remove if elem.content.strip.empty?
      end
    end

    base_whitelist = options[:tags] || %w[div p]
    base_replace_with_whitespace = %w[br hr h1 h2 h3 h4 h5 h6 dl dd ol li ul address blockquote center]

    whitelist = Hash.new
    base_whitelist.each {|tag| whitelist[tag] = true }
    replace_with_whitespace = Hash.new
    base_replace_with_whitespace.each { |tag| replace_with_whitespace[tag] = true }

    node.css("*").each do |el|
      if whitelist[el.node_name]
        el.attributes.each { |a, x| el.delete(a) unless options[:attributes] && options[:attributes].include?(a.to_s) }
      else
        if el.parent.nil?
          node = Nokogiri::XML::Text.new(el.text, el.document)
          break
        else
          if replace_with_whitespace[el.node_name]
            el.swap(Nokogiri::XML::Text.new(' ' << el.text << ' ', el.document))
          else
            el.swap(Nokogiri::XML::Text.new(el.text, el.document))
          end
        end
      end
    end

    return node.to_s.gsub(/[\r\n\f]+/, "\n" )
  end
end
