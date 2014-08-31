module GetEntryBody
  extend ActiveSupport::Concern

  def get_body
    content = filtered_content
    update_attributes(body: content)
    update_attributes(summary: content) if summary.blank?
    reindex
  end

  private

  def source
    open(url, 'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_2) AppleWebKit/537.75.14 (KHTML, like Gecko) Version/7.0.3 Safari/537.75.14').read
  end

  def filtered_content
    content = ContentFactory.new(source, channel.filters.split(' '))
    content.result
  end
end
