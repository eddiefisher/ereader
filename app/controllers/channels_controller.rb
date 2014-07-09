class ChannelsController < ApplicationController
  def index
    @user_channels = current_user.channels
    @other_channels = Channel.other current_user.channel_ids
  end

  def add
    @channel = Channel.find(params[:id])
    current_user.channels << @channel
    redirect_to channels_path
  end

  def remove
    @channel = Channel.find(params[:id])
    current_user.channels.delete(@channel)
    redirect_to channels_path
  end
end
