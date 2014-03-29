class EntriesController < ApplicationController
  before_filter :entry

  def index
    if params.fetch(:channel_id, false)
      @entries = Entry.includes(:channel).where(channel_id: params[:channel_id])
    else
      @entries = Entry.includes(:channel).all
    end
  end

  def show    
  end

  private
  def entry
    @entry = Entry.find(params[:id]) if params[:id]
  end
end
