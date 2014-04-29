class Opennet < Factory
  def execute(source)
    Nokogiri::HTML(source).css('#r_memo')
  end
end
