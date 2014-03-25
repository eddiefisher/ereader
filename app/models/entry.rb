class Entry < ActiveRecord::Base
  default_scope ->{ order(published_at: :desc) }

  def self.update_from_feed(feed_url)
    feed = Feedjira::Feed.fetch_and_parse(feed_url)
    add_entries(feed.entries)
  end
  
  private
  
  def self.add_entries(entries)
    entries.each do |entry|
      create!(
        :name         => entry.title,
        :summary      => entry.summary,
        :url          => entry.url,
        :published_at => entry.published,
        :guid         => entry.id
      ) unless exists?(:guid => entry.id)
    end
  end

  def self.get_body
    source = open(params[:url], "User-Agent" => "Mozilla/5.0 (iPad; CPU OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A5355d Safari/8536.25").read
    @results = Readability::Document.new( source,
                                          tags: %w[div p img a h1 h2 h3 h4 h5 h6 strong code pre span b i blockquote ul ol li dd dt],
                                          attributes: %w[src href class],
                                          remove_empty_nodes: false,
                                          remove_unlikely_candidates: false)
    @results.content
  end
end
