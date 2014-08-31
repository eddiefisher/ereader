class Sanitize < Factory
  def execute(source)
    content_filter(source)
  end

  private
  def content_filter(content)
    content = sanitize(content, readability_options)
    content = content.gsub('<br><blockquote>', '<blockquote>').gsub(/<\/blockquote>(\n)<br>/, '</blockquote>')
    content = content.gsub('<br/><blockquote>', '<blockquote>').gsub('</blockquote><br/>', '</blockquote>')
    content = content.gsub('<a></a>', '')
    content = content.gsub("\t", '  ').gsub('<br><br>', '<br>')
  end

  def sanitize(node, options = {})
    node.css('form, object, embed').each do |elem|
      elem.remove
    end

    node.css('p, a').each do |elem|
      next if elem.css('*').to_a.count > 0
      elem.remove if elem.children.count == 0
    end

    base_whitelist = options[:tags] || %w(div p)
    base_replace_with_whitespace = %w(br hr h1 h2 h3 h4 h5 h6 dl dd ol li ul address blockquote center)

    whitelist = {}
    base_whitelist.each { |tag| whitelist[tag] = true }
    replace_with_whitespace = {}
    base_replace_with_whitespace.each { |tag| replace_with_whitespace[tag] = true }

    node.css('*').each do |el|
      if whitelist[el.node_name]
        el.attributes.each { |a, _| el.delete(a) unless options[:attributes] && options[:attributes].include?(a.to_s) }
      else
        if el.parent.nil?
          node = Nokogiri::XML::Text.new(el.text, el.document)
          break
        else
          if replace_with_whitespace[el.node_name]
            el.swap(Nokogiri::XML::Text.new(" #{el.text} ", el.document))
          else
            el.swap(Nokogiri::XML::Text.new(el.text, el.document))
          end
        end
      end
    end

    return node.to_s.gsub(/[\r\n\f]+/, "\n" )
  end
end
