module RedisInit
  def redis_key(str)
    "#{self.class.name.downcase}:#{id}:#{str}"
  end

  def redis
    $redis
  end
end
