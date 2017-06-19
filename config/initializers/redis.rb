Redis::Objects.redis = Redis.new(url: Figaro.env.redis_db_server)
