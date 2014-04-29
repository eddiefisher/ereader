class Habrahabr < Factory
  def execute(source)
    results = Nokogiri::HTML(source)
    content = results.css('.content.html_format')
    if content.blank?
      content = results.css('#reg-wrapper')
    end
    content
  end
end
