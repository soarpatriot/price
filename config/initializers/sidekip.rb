redis_server = Settings.redis_server
redis_port = Settings.redis_port
redis_password = Settings.redis_password
redis_db_num = Settings.redis_db_num
redis_namespace = Settings.redis_namespace


Sidekiq.configure_server do |config|
  p redis_server
  config.redis = { url: "redis://#{redis_server}:#{redis_port}/#{redis_db_num}", password: redis_password, namespace: redis_namespace }
end

Sidekiq.configure_client do |config|
  config.redis = { url: "redis://#{redis_server}:#{redis_port}/#{redis_db_num}", password: redis_password, namespace: redis_namespace }
end
