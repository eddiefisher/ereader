module EntryReadable
  extend ActiveSupport::Concern

  def read!(user)
    $redis.sadd(self.redis_key(:read_by), user.id)
  end

  def unread!(user)
    $redis.srem(self.redis_key(:read_by), user.id)
  end

  def is_readed?(user)
    $redis.sismember(self.redis_key(:read_by), user.id)
  end

  def is_unreaded?(user)
    !$redis.sismember(self.redis_key(:read_by), user.id)
  end

  def redis_key(str)
    "entry:#{self.id}:#{str}"
  end
end
