class EntrySerializer < ActiveModel::Serializer
  attributes :id, :name, :summary, :body, :url, :published_at, :channel_id, :read

  def read
    object.is_read?(current_user)
  end
end
