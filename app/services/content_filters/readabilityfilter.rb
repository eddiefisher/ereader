class Readabilityfilter < Factory
  def execute(source)
    results = Readability::Document.new source, readability_options
    results.content
  end
end
