module EntryReadable
  extend ActiveSupport::Concern

  def read(value)
    $redis.sadd(self.redis_key(:read), value)
  end

  def unread(value)
    $redis.srem(self.redis_key(:read), value)
  end

  def is_readed?(value)
    $redis.sismember(self.redis_key(:read), value)
  end

  def is_unreaded?(value)
    !$redis.sismember(self.redis_key(:read), value)
  end

  def redis_key(str)
    "user:#{self.id}:#{str}"
  end
end
