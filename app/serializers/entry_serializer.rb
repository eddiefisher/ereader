class EntrySerializer < ActiveModel::Serializer
  attributes :id, :name, :summary, :body, :url, :published_at, :channel_id, :read, :flag, :star

  def read
    object.is_read?(current_user)
  end

  def flag
    object.is_flaged?(current_user)
  end

  def star
    object.is_star?(current_user)
  end
end
