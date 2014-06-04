class ImportController < ApplicationController
  def index
    @new_import = Import.new
    @imports = Import.where(user: current_user)
  end

  def create
    require 'rexml/Document'

    @import = Import.new(import_params)
    import_opml @import if @import.save
    redirect_to import_index_path
  end

  private

  def import_params
    params.require(:import).permit(:name, :user_id)
  end

  def get_opml_feeds(path)
    file = File.open(path, 'r')
    opml = REXML::Document.new(file.read)
    opml.elements['opml/body'].elements.map { |el| el.attributes if el.attributes['xmlUrl'] }.compact
  end

  def import_opml(data)
    get_opml_feeds(data.name.current_path).each do |feed|
      Channel.create(
        text: feed['text'],
        title: feed['title'],
        feed_type: feed['type'],
        xml_url: feed['xmlUrl'],
        html_url: feed['htmlUrl']
      )
    end
  end
end
