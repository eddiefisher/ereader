class CreateUserChannels < ActiveRecord::Migration
  def change
    create_table :user_channels do |t|
      t.belongs_to :user
      t.belongs_to :channel

      t.timestamps
    end

    add_index :user_channels, [:user_id, :channel_id]
  end
end
