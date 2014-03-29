class AddChannelIdToEntry < ActiveRecord::Migration
  def change
    add_reference :entries, :channel, index: true, after: :guid
  end
end
