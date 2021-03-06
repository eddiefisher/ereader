class Factory
  def readability_options
    {
      tags: %w(div p br img a h1 h2 h3 h4 h5 h6 strong code pre span b i blockquote ul ol li dd dt iframe),
      attributes: %w(src href align width height),
      remove_empty_nodes: false,
      remove_unlikely_candidates: false
    }
  end

  def execute(source)
    fail 'You must implement source'
  end
end
