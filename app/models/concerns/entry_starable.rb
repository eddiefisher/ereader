module EntryStarable
  extend ActiveSupport::Concern

  def star(value)
    $redis.sadd(self.redis_key(:star), value)
  end

  def unstar(value)
    $redis.srem(self.redis_key(:star), value)
  end

  def is_stared?(value)
    $redis.sismember(self.redis_key(:star), value)
  end

  def is_unstared?(value)
    !$redis.sismember(self.redis_key(:star), value)
  end

  def stared_entry
    ids = $redis.smembers(self.redis_key(:star))
    Entry.where(:id => ids)
  end

  def redis_key(str)
    "user:#{self.id}:#{str}"
  end
end
