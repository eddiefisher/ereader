class EntriesController < ApplicationController
  before_filter :entry

  def index
    @entries = Entry.all
  end

  def show    
  end

  private
  def entry
    @entry = Entry.find(params[:id]) if params[:id]
  end
end
