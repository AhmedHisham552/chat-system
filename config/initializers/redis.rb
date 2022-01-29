redis_host = "localhost"
redis_port = 6379
REDIS = Redis.new(url: ENV.fetch('REDIS_URL',"redis://localhost:6379/0"))
