class Habrahabr < Factory
  def execute(source)
    results = Nokogiri::HTML(source)
    content = results.css('.content.html_format')
    content = results.css('#reg-wrapper') if content.blank?
    content
  end
end
