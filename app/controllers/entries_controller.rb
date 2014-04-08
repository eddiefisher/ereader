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

  def action
    @method = params[:method]
    @entry = Entry.find(params[:id])
    @entry.send("#{params[:method]}!", current_user) unless @entry.send("is_#{@method}ed?", current_user)
  end

  def batch_actions
    @method = params['method']
    @entries = Entry.where(id: params[:entry][:ids])
    @entries.each { |entry| entry.send("#{params[:method]}!", current_user) unless entry.send("is_#{params[:method]}ed?", current_user) }
  end

  def get_body
    @entry.get_body
  end

  private

  def entry
    @entry = Entry.find(params[:id]) if params[:id]
  end
end
