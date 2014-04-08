module EntryFlagable
  extend ActiveSupport::Concern

  def flag!(user)
    $redis.sadd(self.redis_key(:flag_by), user.id)
  end

  def unflag!(user)
    $redis.srem(self.redis_key(:flag_by), user.id)
  end

  def is_flaged?(user)
    $redis.sismember(self.redis_key(:flag_by), user.id)
  end

  def is_unflaged?(user)
    !$redis.sismember(self.redis_key(:flag_by), user.id)
  end

  def redis_key(str)
    "entry:#{self.id}:#{str}"
  end
end
