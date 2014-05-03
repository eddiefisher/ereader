class EntriesController < ApplicationController
  before_action :entry
  respond_to :html, :js

  def index
    if params.fetch(:channel_id, false)
      @entries = Entry.includes(:channel).where(channel_id: params[:channel_id]).limit(40)
    else
      @entries = Entry.includes(:channel).where('entries.published_at > ?', 1.day.ago)
    end
  end

  def flaged
    @entries = current_user.flaged_entry
    render :index
  end

  def stared
    @entries = current_user.stared_entry
    render :index
  end

  def show
    current_user.read(@entry.id)
    @entry
  end

  def action
    @method = params[:method]
    @entry = Entry.find(params[:id])
    entry_action @entry, @method
  end

  def batch_actions
    @method = params['method']
    @entries = Entry.where(id: params[:entry][:ids])
    @entries.each { |entry| entry_action entry, @method }
  end

  def get_body
    @entry.get_body
  end

  private

  def entry
    @entry = Entry.find(params[:id]) if params[:id]
  end

  def entry_action entry, method
    current_user.send("#{method}", entry.id) unless current_user.send("is_#{method}ed?", entry.id)
  end
end
