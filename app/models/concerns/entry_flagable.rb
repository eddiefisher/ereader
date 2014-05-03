module EntryFlagable
  extend ActiveSupport::Concern

  def flag(value)
    $redis.sadd(self.redis_key(:flag), value)
  end

  def unflag(value)
    $redis.srem(self.redis_key(:flag), value)
  end

  def is_flagged?(value)
    $redis.sismember(self.redis_key(:flag), value)
  end

  def is_unflagged?(value)
    !$redis.sismember(self.redis_key(:flag), value)
  end

  def flagged_entry
    ids = $redis.smembers(self.redis_key(:flag))
    Entry.where(:id => ids)
  end

  def redis_key(str)
    "user:#{self.id}:#{str}"
  end
end
