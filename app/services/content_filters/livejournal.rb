class Livejournal < Factory
  def execute(source)
    Nokogiri::HTML(source).css('.b-singlepost-body')
  end
end
