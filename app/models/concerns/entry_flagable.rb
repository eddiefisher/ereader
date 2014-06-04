module EntryFlagable
  extend ActiveSupport::Concern

  def flag(value)
    redis.sadd(redis_key(:flag), value)
  end

  def unflag(value)
    redis.srem(redis_key(:flag), value)
  end

  def flagged?(value)
    redis.sismember(redis_key(:flag), value)
  end

  def unflagged?(value)
    !redis.sismember(redis_key(:flag), value)
  end

  def flagged_entry
    ids = redis.smembers(redis_key(:flag))
    Entry.where(id: ids)
  end

  def redis_key(str)
    "user:#{id}:#{str}"
  end

  def redis
    $redis
  end
end
