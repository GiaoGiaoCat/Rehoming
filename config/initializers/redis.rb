require 'redis-namespace'
redis_connection = Redis.new(url: Figaro.env.redis_db_server)
Redis.current = Redis::Namespace.new(:db, redis: redis_connection)
