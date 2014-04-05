module EntryStarable
  extend ActiveSupport::Concern

  def star!(user)
    $redis.sadd(self.redis_key(:star_by), user.id)
  end

  def unstar!(user)
    $redis.srem(self.redis_key(:star_by), user.id)
  end

  def is_star?(user)
    $redis.sismember(self.redis_key(:star_by), user.id)
  end

  def redis_key(str)
    "entry:#{self.id}:#{str}"
  end
end
