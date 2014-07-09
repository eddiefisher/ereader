module RedisReadable
  def read(value)
    redis.sadd(redis_key(:read), value)
  end

  def unread(value)
    redis.srem(redis_key(:read), value)
  end

  def readed?(value)
    redis.sismember(redis_key(:read), value)
  end

  def read_count
    redis.scard(self.redis_key(:read))
  end

  def unreaded?(value)
    !redis.sismember(redis_key(:read), value)
  end
end
