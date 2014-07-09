module EntriesHelper
  def active_channels
    Channel.where(locked: false)
  end

  def subscribed_channel?(channel)
    current_user.channel_ids.include?(channel.to_i)
  end

  def subscribe_channel(channel)
    return if subscribed_channel?(channel)
    content_tag :span, class: :add do
      link_to 'Add this channel', add_channel_path(id: channel)
    end
  end
end
