class Factory
  def readability_options
    {
      tags: %w[div p br img a h1 h2 h3 h4 h5 h6 strong code pre span b i blockquote ul ol li dd dt],
      attributes: %w[src href align],
      remove_empty_nodes: false,
      remove_unlikely_candidates: false
    }
  end

  def execute(source)
    raise 'You must implement source'
  end
end
