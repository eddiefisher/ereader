class UserChannel < ActiveRecord::Base
  searchkick

  belongs_to :user
  belongs_to :channel

  scope :user_channel_ids, ->(user) { search('*', where: { user_id: user }, fields: [:user_id]).results.map(&:channel_id) }
  scope :user_channels, ->(user) { search('*', where: { user_id: user }) }
end
