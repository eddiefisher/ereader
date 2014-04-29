class Seasonvar < Factory
  def execute(source)
    results = Nokogiri::HTML(source)
    results.css('.rating, script').remove
    results.css('.full-news-1')
  end
end
