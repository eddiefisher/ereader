class AddLastFeedShaToChannel < ActiveRecord::Migration
  def change
    add_column :channels, :last_feed_sha, :string, after: :locked_at
  end
end
