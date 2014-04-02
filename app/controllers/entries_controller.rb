class EntriesController < ApplicationController
  before_filter :entry

  def index
    if params.fetch(:channel_id, false)
      @entries = Entry.includes(:channel).where(channel_id: params[:channel_id]).where('entries.published_at > ?', 1.day.ago)
    else
      @entries = Entry.includes(:channel).where('entries.published_at > ?', 1.day.ago)
    end
  end

  def show
    @entry.read!(current_user)
    @entry
  end

  def get_body
    @entry.get_body
    redirect_to entry_path(@entry)
  end

  private

  def entry
    @entry = Entry.find(params[:id]) if params[:id]
  end
end
