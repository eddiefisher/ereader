module EntryReadable
  extend ActiveSupport::Concern

  def read(value)
    redis.sadd(redis_key(:read), value)
  end

  def unread(value)
    redis.srem(redis_key(:read), value)
  end

  def readed?(value)
    redis.sismember(redis_key(:read), value)
  end

  def unreaded?(value)
    !redis.sismember(redis_key(:read), value)
  end

  def redis_key(str)
    "user:#{id}:#{str}"
  end

  def redis
    $redis
  end
end
