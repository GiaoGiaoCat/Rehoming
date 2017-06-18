# Redis.current = Redis.new(host: '127.0.0.1', port: 6379, db: 1)
require 'redis'
$redis = Redis.new(host: '127.0.0.1', port: 6379, db: 1)
