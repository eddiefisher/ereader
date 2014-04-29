class Xkcd < Factory
  def execute(source)
    Nokogiri::HTML(source).css('#comic')
  end
end
