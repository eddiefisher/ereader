class ImportController < ApplicationController
  def index
    @new_import = Import.new
    @imports = Import.where(user: current_user)
  end

  def create
    require 'rexml/Document'

    @import = Import.new(import_params)
    if @import.save
      import_opml @import
    end
    redirect_to import_index_path
  end

  private

  def import_params
    params.require(:import).permit(:name, :user_id)
  end

  def parse_opml(opml_node, parent_names=[])
    opml_node.elements.map { |el| el.attributes if el.attributes['xmlUrl'] }.compact
  end

  def import_opml data
    file = File.open(data.name.current_path, 'r')
    opml = REXML::Document.new(file.read)
    feeds = parse_opml(opml.elements['opml/body'])
    feeds.each do |feed|
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
