class EntriesController < ApplicationController
  before_action :entry
  respond_to :html, :js
  def index
    if params.fetch(:channel_id, false)
      @entries = Entry.includes(:channel).where(channel_id: params[:channel_id]).limit(20)
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
  end

  private

  def entry
    @entry = Entry.find(params[:id]) if params[:id]
  end
end
