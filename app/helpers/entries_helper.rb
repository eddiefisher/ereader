module EntriesHelper
  def active_channels
    Channel.where(locked: false)
  end
end
