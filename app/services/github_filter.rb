class GithubFilter
  def initialize(data)
    @data = data
  end

  def filter
    filter_content
  end

  private

  def filter_content
    page = Nokogiri::HTML(@data)
    page.css('.content html_format')
  end
end
