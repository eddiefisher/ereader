module RedisStarable
  def star(value)
    redis.sadd(redis_key(:star), value)
  end

  def unstar(value)
    redis.srem(redis_key(:star), value)
  end

  def starred?(value)
    redis.sismember(redis_key(:star), value)
  end

  def unstarred?(value)
    !redis.sismember(redis_key(:star), value)
  end

  def starred_count
    redis.scard(self.redis_key(:star))
  end

  def starred_entry
    ids = redis.smembers(redis_key(:star))
    Entry.where(id: ids)
  end
end
